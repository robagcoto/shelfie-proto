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
  - ingredients_recipes (object): a nested object listing each ingredient, where each ingredient key is unique (e.g., "ingredient1"), and each ingredient contains:
    - name (string)
    - quantity (number), must be g,l or pc(s)
    - unit (string)

- recipe_description: a human-readable, well-formatted textual recipe combining the above info, excluding the favorites key, styled like a cookbook entry.

The response must be only in JSON format, with no additional text or explanation.

The recipe description and all texts must be in English regardless of the input language.
this  what the output must seems
{
  "recipe_attributes": {
    "name": "Lemon Poppy Seed Muffins",
    "description": "These Lemon Poppy Seed Muffins are light, fluffy, and bursting with zesty lemon flavor. The addition of poppy seeds provides a subtle crunch, making them the perfect morning treat or afternoon snack. Topped with a tangy lemon glaze, they offer a bright and refreshing bite.",
    "rating": 4.7,
    "category": "Dessert",
    "favorites": true,
    "duration": "30",
    "steps": {
      "step1": "Preheat the oven to 375°F (190°C) and line a muffin tin with paper liners.",
      "step2": "In a large bowl, whisk together flour, baking powder, baking soda, salt, and poppy seeds.",
      "step3": "In another bowl, combine sugar, eggs, melted butter, yogurt, lemon juice, lemon zest, and vanilla extract until smooth.",
      "step4": "Gradually add the dry ingredients to the wet ingredients, stirring until just combined. Do not overmix.",
      "step5": "Divide the batter evenly among the muffin cups, filling each about 3/4 full.",
      "step6": "Bake for 18–20 minutes, or until a toothpick inserted in the center comes out clean.",
      "step7": "While muffins cool, mix powdered sugar and lemon juice to make the glaze.",
      "step8": "Drizzle the glaze over the cooled muffins and let set before serving."
    },
    "ingredients_recipes": {
      "ingredient1": {
        "name": "all-purpose flour",
        "quantity": 2,
        "unit": "cups"
      },
      "ingredient2": {
        "name": "baking powder",
        "quantity": 1,
        "unit": "teaspoon"
      },
      "ingredient3": {
        "name": "baking soda",
        "quantity": 0.5,
        "unit": "teaspoon"
      },
      "ingredient4": {
        "name": "salt",
        "quantity": 0.25,
        "unit": "teaspoon"
      },
      "ingredient5": {
        "name": "poppy seeds",
        "quantity": 2,
        "unit": "tablespoons"
      },
      "ingredient6": {
        "name": "granulated sugar",
        "quantity": 0.75,
        "unit": "cup"
      },
      "ingredient7": {
        "name": "eggs",
        "quantity": 2,
        "unit": "pieces"
      },
      "ingredient8": {
        "name": "unsalted butter",
        "quantity": 0.5,
        "unit": "cup"
      },
      "ingredient9": {
        "name": "plain yogurt",
        "quantity": 0.5,
        "unit": "cup"
      },
      "ingredient10": {
        "name": "lemon juice",
        "quantity": 0.25,
        "unit": "cup"
      },
      "ingredient11": {
        "name": "lemon zest",
        "quantity": 1,
        "unit": "tablespoon"
      },
      "ingredient12": {
        "name": "vanilla extract",
        "quantity": 1,
        "unit": "teaspoon"
      },
      "ingredient13": {
        "name": "powdered sugar",
        "quantity": 0.5,
        "unit": "cup"
      },
      "ingredient14": {
        "name": "lemon juice (for glaze)",
        "quantity": 2,
        "unit": "tablespoons"
      }
    }
  },
  "recipe_description": "Lemon Poppy Seed Muffins\n\nThese Lemon Poppy Seed Muffins are light, fluffy, and bursting with zesty lemon flavor. The addition of poppy seeds provides a subtle crunch, making them the perfect morning treat or afternoon snack. Topped with a tangy lemon glaze, they offer a bright and refreshing bite.\n\nCategory: Dessert  \nRating: 4.7/5  \nDuration: 30 minutes\n\nIngredients:\n- 2 cups all-purpose flour\n- 1 teaspoon baking powder\n- 0.5 teaspoon baking soda\n- 0.25 teaspoon salt\n- 2 tablespoons poppy seeds\n- 0.75 cup granulated sugar\n- 2 eggs\n- 0.5 cup unsalted butter (melted)\n- 0.5 cup plain yogurt\n- 0.25 cup lemon juice\n- 1 tablespoon lemon zest\n- 1 teaspoon vanilla extract\n- 0.5 cup powdered sugar\n- 2 tablespoons lemon juice (for glaze)\n\nSteps:\n1. Preheat the oven to 375°F (190°C) and line a muffin tin with paper liners.\n2. In a large bowl, whisk together flour, baking powder, baking soda, salt, and poppy seeds.\n3. In another bowl, combine sugar, eggs, melted butter, yogurt, lemon juice, lemon zest, and vanilla extract until smooth.\n4. Gradually add the dry ingredients to the wet ingredients, stirring until just combined. Do not overmix.\n5. Divide the batter evenly among the muffin cups, filling each about 3/4 full.\n6. Bake for 18–20 minutes, or until a toothpick inserted in the center comes out clean.\n7. While muffins cool, mix powdered sugar and lemon juice to make the glaze.\n8. Drizzle the glaze over the cooled muffins and let set before serving."
}

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

end
