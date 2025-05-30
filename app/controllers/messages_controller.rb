require 'json'

class MessagesController < ApplicationController

  SYSTEM_PROMPT = <<-PROMPT
  You are a consice and professional chef assistant.
  Please provide a recipe to our user in HTML format
  Your responses are going to be in english even if part of the prompt is in a different language
  The recipe must contain:
    A "name",
    A "description",
    A "rating",
    A "category" exclusively included in this array VALID_CATEGORIES = ['French', 'Italian', 'Japanese', 'Mexican', 'Indian', 'Chinese', 'Thai', 'Greek', 'Spanish', 'Moroccan', 'American', 'Vietnamese', 'Lebanese', 'Korean', 'Turkish']
    A "duration" in minutes
    the "steps" of preparation
    and "ingredients" with this measurements exclusively : ['l', 'g', 'pc(s)']
    If there are elements after this sentence, only take into consideration dietary restriction instructions or preference instructions
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
    [SYSTEM_PROMPT, current_user.prompt_setting].compact.join("\n\n")
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
