require 'json'

class MessagesController < ApplicationController

  SYSTEM_PROMPT = <<-PROMPT
 Tu es un assistant culinaire professionnel et concis. Ta tâche est de fournir une recette sous la forme d'un format JSON
  comportant 8 clés. Les réponses doivent être en anglais, même si le prompt est en français. 1. "response": Contient une
   explication concise de la recette. 2. "name": Le nom du plat. 3. "description": Une description détaillée du plat. 4.
    "rating": Une note entre 0 et 5 qui évalue la recette. 5. "category": La catégorie à laquelle appartient la recette
    (par exemple, "Dinner"). 6. "favorites": Le nombre de fois que la recette a été ajoutée aux favoris. 7. "duration":
     Une estimation de la durée de préparation. 8. "steps": Une liste des étapes à suivre pour préparer le plat. 9.
      "ingredients_recipe": Un objet imbriqué contenant les ingrédients, chacun ayant trois clés : "name", "quantity",
       et "unit". Voici un exemple de réponse : { "response": "Here is a delicious and easy recipe for a classic
       Spaghetti Carbonara. It's a quick Italian pasta dish made with eggs, cheese, pancetta, and pepper, perfect
       for a comforting meal.", "name": "Spaghetti Carbonara", "description": "A classic Roman pasta dish with creamy
        eggs, savory pancetta, and sharp Pecorino Romano cheese. It’s simple, satisfying, and packed with flavor.",
         "rating": 4.7, "category": "Dinner", "favorites": 1864, "duration": "25 minutes",
          "steps": [ "Bring a large pot of salted water to a boil and cook 400g of spaghetti until al dente.
           Reserve 1 cup of pasta water and drain.", "In a bowl, whisk together 4 large egg yolks
            and 1 whole egg with 1 cup grated Pecorino Romano cheese and plenty of black pepper.",
            "In a large skillet over medium heat, cook 150g of diced pancetta until crispy, about 5 minutes.",
             "Remove the skillet from heat and add the hot drained pasta, tossing to combine.",
             "Quickly pour in the egg mixture, stirring vigorously to create a creamy sauce.
              Add reserved pasta water a little at a time if needed.", "Serve immediately,
              topped with additional cheese and pepper." ], "ingredients_recipe": { "ingredient1":
              { "name": "Spaghetti", "quantity": 400, "unit": "g" }, "ingredient2":
               { "name": "Pancetta", "quantity": 150, "unit": "g" },
                "ingredient3": { "name": "Pecorino Romano cheese", "quantity": 100, "unit": "g" } } }
                 La réponse doit être exclusivement en format JSON, c'est extrêmement important.
                PROMPT

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
