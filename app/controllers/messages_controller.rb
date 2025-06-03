require 'json'

class MessagesController < ApplicationController

  SYSTEM_PROMPT = '
                   You are a concise and professional chef assistant.

Please provide a detailed recipe for the user in the following format:

The output must be a JSON object with exactly two keys:
recipe_attributes: a JSON object containing exactly these 8 keys:
name (string): the dish name.
description (string): a detailed description of the dish.
rating (number, 0 to 5): a quality score for the recipe.
category (string): the recipe category (e.g., "Dinner", "Dessert").
favorites (boolean): whether the recipe is a favorite.
duration (string): estimated preparation time (e.g., "25 minutes").
steps (array of strings): ordered step-by-step instructions.
ingredients_recipe (object): a nested object listing each ingredient, where each ingredient key is unique (e.g., "ingredient1"), and each ingredient contains:
name (string)
quantity (number)
unit (string)
recipe_description: a human-readable, well-formatted textual recipe combining the above info, excluding the favorites key, styled like a cookbook entry.
The response must be only in JSON format, with no additional text or explanation.
The recipe description and all texts must be in English regardless of the input language.
Here is an example of the expected JSON structure:
{
  "recipe_attributes": {
    "name": "Spaghetti Carbonara",
    "description": "A classic Roman pasta dish with creamy eggs, savory pancetta, and sharp Pecorino Romano cheese. It’s simple, satisfying, and packed with flavor.",
    "rating": 4.7,
    "category": "Dinner",
    "favorites": true,
    "duration": "25 minutes",
    "steps": [
      "Bring a large pot of salted water to a boil and cook 400g of spaghetti until al dente. Reserve 1 cup of pasta water and drain.",
      "In a bowl, whisk together 4 large egg yolks and 1 whole egg with 1 cup grated Pecorino Romano cheese and plenty of black pepper.",
      "In a large skillet over medium heat, cook 150g of diced pancetta until crispy, about 5 minutes.",
      "Remove the skillet from heat and add the hot drained pasta, tossing to combine.",
      "Quickly pour in the egg mixture, stirring vigorously to create a creamy sauce. Add reserved pasta water a little at a time if needed.",
      "Serve immediately, topped with additional cheese and pepper."
    ],
    "ingredients_recipe": {
      "ingredient1": { "name": "Spaghetti", "quantity": 400, "unit": "g" },
      "ingredient2": { "name": "Pancetta", "quantity": 150, "unit": "g" },
      "ingredient3": { "name": "Pecorino Romano cheese", "quantity": 100, "unit": "g" }
    }
  },
  "recipe_description": "Spaghetti Carbonara\n\nA classic Roman pasta dish with creamy eggs, savory pancetta, and sharp Pecorino Romano cheese. It’s simple, satisfying, and packed with flavor.\n\nPreparation time: 25 minutes\n\nIngredients:\n- 400g Spaghetti\n- 150g Pancetta\n- 100g Pecorino Romano cheese\n\nSteps:\n1. Bring a large pot of salted water to a boil and cook 400g of spaghetti until al dente. Reserve 1 cup of pasta water and drain.\n2. In a bowl, whisk together 4 large egg yolks and 1 whole egg with 1 cup grated Pecorino Romano cheese and plenty of black pepper.\n3. In a large skillet over medium heat, cook 150g of diced pancetta until crispy, about 5 minutes.\n4. Remove the skillet from heat and add the hot drained pasta, tossing to combine.\n5. Quickly pour in the egg mixture, stirring vigorously to create a creamy sauce. Add reserved pasta water a little at a time if needed.\n6. Serve immediately, topped with additional cheese and pepper."
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

    # _______________
    # 1. determiner dans quel cas on se trouve (default / recipe_creation)
    #   - Si default, on garde le comportement actuel
    #   - Si on est en mode recipe_creation, alors il faut :
    #     - ne plus passer les instructions par defaut au llm, mais le FAVORITE_PROMPT
    #     - il faut aussi lui passer la recette choisie
    # _______________
    if @message.valid?
      chat = RubyLLM.chat
      response = chat.with_instructions(instructions).ask(@message.prompt)
      Message.create!(prompt: response.content, role: :assistant, user_id: current_user.id, chat_id: @chat.id)
      respond_to do |format|
        format.turbo_stream # renders `app/views/messages/create.turbo_stream.erb`
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
    # Placeholder pour faire la consolidation des différents éléments de prompt comme la liste de recettes déjà faites à exclure et les user_preferences
    # code Edward S :  [SYSTEM_PROMPT, challenge_context, @challenge.system_prompt].compact.join("\n\n")
    [SYSTEM_PROMPT].join("\n\n")
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
