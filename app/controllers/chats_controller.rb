class ChatsController < ApplicationController

  SYSTEM_PROMPT = <<-PROMPT
 You are a concise and professional chef assistant.

Please provide a detailed recipe for the user in the following format:

The output must be a JSON object with exactly two keys:

- recipe_attributes: a JSON object containing exactly these 8 keys:
  - name (string): the dish name.
  - description (string): a detailed description of the dish.
  - rating (number, 0 to 5): a quality score for the recipe.
  - category (string): the recipe category (e.g., "Dinner", "Dessert").
  - favorites (boolean): whether the recipe is a favorite.
  - duration (string): estimated preparation time (e.g., "25 minutes").
  - steps (object): an ordered set of step instructions using unique keys (e.g., "step1", "step2", etc.), where each value is a string describing the step.
  - ingredients_recipe (object): a nested object listing each ingredient, where each ingredient key is unique (e.g., "ingredient1"), and each ingredient contains:
    - name (string)
    - quantity (number)
    - unit (string)

- recipe_description: a human-readable, well-formatted textual recipe combining the above info, excluding the favorites key, styled like a cookbook entry.

The response must be only in JSON format, with no additional text or explanation.

The recipe description and all texts must be in English regardless of the input language.
                    PROMPT

  def index
    @chats = Chat.where(user_id: current_user)
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = current_user.chats.new(title: "Untitled")
    if @chat.save
      prompt = params[:chat][:prompt]
      user_message = @chat.messages.create!(prompt: prompt, role: "user", user_id: current_user.id)

      # Génère un titre
      @chat.generate_title_from_first_message

      # Appel LLM
      chat = RubyLLM.chat
      response = chat.with_instructions(instructions).ask(prompt)

      begin
        parsed = JSON.parse(response.content)
        recipe_data = parsed["recipe_attributes"]
        description_text = parsed["recipe_description"]

        # Création de la recette
        recipe = Recipe.new(
          name: recipe_data["name"],
          description: recipe_data["description"],
          rating: recipe_data["rating"],
          category: recipe_data["category"],
          duration: recipe_data["duration"],
          favorite: recipe_data["favorites"],
          number_of_ingredients: recipe_data["ingredients_recipe"].size,
          user: current_user
        )

        if recipe.save
          # Ajout des ingrédients
          recipe_data["ingredients_recipes"].each_value do |ingredient|
            recipe.ingredients_recipes.create!(
              name: ingredient["name"],
              quantity: ingredient["quantity"],
              unit: ingredient["unit"]
            )
          end

          # Ajout des étapes
          recipe_data["steps"].each do |_, step_description|
            Step.create!(recipe: recipe, description: step_description)
          end

          # Message assistant avec la recette en texte lisible
          @assistant_message = @chat.messages.create!(
            prompt: description_text,
            role: :assistant,
            user_id: current_user.id
          )

          flash[:notice] = "Recette créée avec succès 🎉"
          redirect_to recipe_path(recipe) and return
        else
          flash[:alert] = "Erreur lors de l'enregistrement de la recette."
        end
      rescue JSON::ParserError => e
        flash[:alert] = "Erreur de parsing JSON : #{e.message}"
      rescue => e
        flash[:alert] = "Erreur lors de la création de la recette : #{e.message}"
      end


      # Fallback message
      @chat.messages.create!(
        prompt: response.content,
        role: :assistant,
        user_id: current_user.id
      )

      redirect_to chat_messages_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end


  def destroy
    @chat = current_user.chats.find(params[:id])
    @chat.destroy
    redirect_to chats_path, notice: "Hasta la vista, baby..."
  end

  private

  def instructions
    [SYSTEM_PROMPT, current_user.prompt_setting].compact.join("\n\n")
  end
end
