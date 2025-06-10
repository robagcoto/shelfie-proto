class ChatsController < ApplicationController

SYSTEM_PROMPT = '
  You are a concise and professional chef assistant.

  Please provide a detailed recipe for the user in the following format:

  The output must be a JSON object with exactly two primary keys:

  - recipe_attributes: a JSON object containing exactly these 9 keys:
    - name (string): the dish name.
    - description (string): a detailed description of the dish.
    - my_recipe (boolean): whether the recipe is not a favorite.
    - rating (number, 0 to 5): a quality score for the recipe.
    - category (string): the recipe category (e.g., "Dinner", "Dessert").
    - favorites (boolean): whether the recipe is not a favorite.
    - duration (string): estimated preparation time (e.g., "25 minutes").
    - steps (object): an ordered set of step instructions using unique keys (e.g., "step1", "step2", etc.), where each value is a string describing the step.
    - ingredients_recipes (object): a nested object listing each ingredient, where each ingredient key is unique (e.g., "ingredient1"), and each ingredient contains:
      - name (string)
      - quantity (number)
      - unit with the unit being either grams (g), liters (l), or pieces(string)

  - recipe_description: a human-readable, well-formatted textual recipe combining the above info, excluding the favorites key, styled like a cookbook entry.

  The response must be only in JSON format, with no additional text or explanation.

  The recipe description and all texts must be in English regardless of the input language.
  this  what the output must looks like
 {
  "recipe_attributes": {
    "name": "Creamy Mushroom Risotto",
    "description": "A rich and creamy Italian rice dish infused with the earthy flavors of mushrooms, parmesan cheese, and a hint of white wine. This comforting recipe is perfect for a cozy dinner and showcases the luxurious texture of arborio rice slowly cooked to perfection.",
    "rating": 4.7,
     "favorites": false,
    "category": "Dinner",
    "favorites": false,
    "duration": "45 minutes",
    "steps": {
      "step1": "Heat the olive oil and 25g of butter in a large saucepan over medium heat.",
      "step2": "Add the chopped onion and sauté until translucent, about 5 minutes.",
      "step3": "Stir in the sliced mushrooms and cook until they release their juices and are golden brown, about 8 minutes.",
      "step4": "Add the arborio rice and stir to coat with the mushroom mixture, cooking for 1–2 minutes.",
      "step5": "Pour in the white wine and stir until it is mostly absorbed.",
      "step6": "Gradually add the warm vegetable broth, one ladle at a time, stirring constantly and allowing each addition to absorb before the next.",
      "step7": "Continue this process until the rice is creamy and al dente, about 20–25 minutes.",
      "step8": "Remove from heat and stir in the remaining butter, grated parmesan cheese, salt, and pepper.",
      "step9": "Let it rest for 2 minutes before serving hot, optionally garnished with fresh parsley."
    },
    "ingredients_recipes": {
      "ingredient1": {
        "name": "Arborio rice",
        "quantity": 300,
        "unit": "g"
      },
      "ingredient2": {
        "name": "Mushrooms",
        "quantity": 250,
        "unit": "g"
      },
      "ingredient3": {
        "name": "Onion",
        "quantity": 1,
        "unit": "pieces"
      },
      "ingredient4": {
        "name": "Olive oil",
        "quantity": 2,
        "unit": "l"
      },
      "ingredient5": {
        "name": "Butter",
        "quantity": 50,
        "unit": "g"
      },
      "ingredient6": {
        "name": "White wine",
        "quantity": 100,
        "unit": "l"
      },
      "ingredient7": {
        "name": "Vegetable broth",
        "quantity": 1,
        "unit": "l"
      },
      "ingredient8": {
        "name": "Parmesan cheese",
        "quantity": 50,
        "unit": "g"
      },
      "ingredient9": {
        "name": "Salt",
        "quantity": 5,
        "unit": "g"
      },
      "ingredient10": {
        "name": "Black pepper",
        "quantity": 2,
        "unit": "g"
      },
      "ingredient11": {
        "name": "Parsley (optional)",
        "quantity": 1,
        "unit": "pieces"
      }
    }
  },
  "recipe_description": "Creamy Mushroom Risotto\n\nA rich and creamy Italian rice dish infused with the earthy flavors of mushrooms, parmesan cheese, and a hint of white wine. This comforting recipe is perfect for a cozy dinner and showcases the luxurious texture of arborio rice slowly cooked to perfection.\n\nPrep & Cook Time: 45 minutes\nRating: 4.7/5\nCategory: Dinner\n\nIngredients:\n- 300g Arborio rice\n- 250g Mushrooms, sliced\n- 1 Onion, finely chopped\n- 2l Olive oil\n- 50g Butter\n- 100l White wine\n- 1l Vegetable broth, warm\n- 50g Parmesan cheese, grated\n- 5g Salt\n- 2g Black pepper\n- 1 piece Parsley (optional, for garnish)\n\nSteps:\n1. Heat the olive oil and 25g of butter in a large saucepan over medium heat.\n2. Add the chopped onion and sauté until translucent, about 5 minutes.\n3. Stir in the sliced mushrooms and cook until they release their juices and are golden brown, about 8 minutes.\n4. Add the arborio rice and stir to coat with the mushroom mixture, cooking for 1–2 minutes.\n5. Pour in the white wine and stir until it is mostly absorbed.\n6. Gradually add the warm vegetable broth, one ladle at a time, stirring constantly and allowing each addition to absorb before the next.\n7. Continue this process until the rice is creamy and al dente, about 20–25 minutes.\n8. Remove from heat and stir in the remaining butter, grated parmesan cheese, salt, and pepper.\n9. Let it rest for 2 minutes before serving hot, optionally garnished with fresh parsley."
}

'

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
      chat = RubyLLM.chat(
        model: 'openai/gpt-3.5-turbo',
        provider: 'openrouter',
        assume_model_exists: true
      )
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
          number_of_ingredients: recipe_data["ingredients_recipes"].size,
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
        else
          flash[:alert] = "Erreur lors de l'enregistrement de la recette."
        end
      rescue JSON::ParserError => e
        flash[:alert] = "Erreur de parsing JSON : #{e.message}"
        @chat.messages.create!(
          prompt: response.content,
          role: :assistant,
          user_id: current_user.id
        )
      rescue => e
        flash[:alert] = "Erreur lors de la création de la recette : #{e.message}"
        @chat.messages.create!(
          prompt: response.content,
          role: :assistant,
          user_id: current_user.id
        )
      end

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
