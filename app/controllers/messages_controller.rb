require 'json'

class MessagesController < ApplicationController

  SYSTEM_PROMPT = '
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
  '

  def index
    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages.order(:created_at)
    @message = Message.new
  end

  # def new
  #     @chat = Chat.find(params[:chat_id])
  #     @message = @chat.messages.new
  # end

  # ---------------------------------------------------------------------------
  # modif hotwire
  # ---------------------------------------------------------------------------

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(message_params.merge(role: :user))
    @message.user_id = current_user.id

    if @message.save
      chat = RubyLLM.chat
      response = chat.with_instructions(instructions).ask(@message.prompt)

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
          recipe_data["ingredients_recipe"].each_value do |ingredient|
            recipe.ingredients_recipes.create!(
              name: ingredient["name"],
              quantity: ingredient["quantity"],
              unit: ingredient["unit"]
            )
          end

          # Ajout des étapes
          recipe_data["steps"].sort_by { |key, _| key.gsub("step", "").to_i }.each do |_, step_description|
            recipe.steps.create!(description: step_description)
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

      # En cas d'erreur, on affiche quand même la réponse brute
      @chat.messages.create!(
        prompt: response.content,
        role: :assistant,
        user_id: current_user.id
      )

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_messages_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "new_message",
            partial: "messages/form",
            locals: { chat: @chat, message: @message }
          )
        }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.find(params[:id])
    @message.destroy
    redirect_to chat_messages_path(@chat), notice: "Hasta la vista, baby..."
  end

  private

  def message_params
    params.require(:message).permit(:prompt)
  end

  def instructions
    [SYSTEM_PROMPT, current_user.prompt_setting].compact.join("\n\n")
  end

  def json_recipe
    [FAVORITE_PROMPT].join("\n\n")
  end
end

      # parsed_response = JSON.parse(response.content)
      #   recipe_response = parsed_response["response"]
      #   recipe_name = parsed_response["name"]
      #   recipe_description = parsed_response["description"]
      #   recipe_rating = parsed_response["rating"]
      #   recipe_category = parsed_response["category"]
      #   recipe_favorites = parsed_response["favorites"]
      #   recipe_duration = parsed_response["duration"]
      #   recipe_steps = parsed_response["steps"]
      #   recipe_ingredients_hash = parsed_response["ingredients_recipe"]
