class MessagesController < ApplicationController

  SYSTEM_PROMPT = "
  You are a consice professional chef assistant.
  Please provide a recipe to our user.
  The recipe must contain: A description, a list of ingredients, an estimated duration of preparation and a step by step.
  Your responses are going to be in english even if part of the prompt is in a different language
  "

  def index
    @messages = current_user.messages
    @message = current_user.messages.new
  end

  def new
    if params[:chat_id].present?
      @chat = Chat.find_by(id: params[:chat_id])
      if @chat
        @message = @chat.messages.new
      else
        redirect_to chats_path, alert: "Ce chat n'existe pas." and return
      end
    else
      @message = Message.new
    end
  end


# ---------------------------------------------------------------------------
# modif pour hotwire
# ---------------------------------------------------------------------------

#   def create
#   @message = current_user.messages.new(message_params.merge(role: :user))

#   if @message.valid?
#     chat = RubyLLM.chat
#     response = chat.with_instructions(instructions).ask(@message.prompt)
#     Message.create(prompt: response.content, role: :assistant, user: current_user)

#     respond_to do |format|
#       format.turbo_stream
#       format.html { redirect_to messages_path }
#     end
#   else
#     respond_to do |format|
#       format.turbo_stream {
#         render turbo_stream: turbo_stream.replace(
#           "new_message",
#           partial: "messages/form",
#           locals: { chat: @chat, message: @message }
#         )
#       }
#       format.html { render :new, status: :unprocessable_entity }
#     end
#   end
# end


# ---------------------------------------------------------------------------
# ancienne version de create, à garder pour référence
# ---------------------------------------------------------------------------

  def create
    @message = current_user.messages.new(message_params.merge(role: :user))
    if @message.save
      chat = RubyLLM.chat
      response = chat.with_instructions(instructions).ask(@message.prompt)
      Message.create(prompt: response.content, role: :assistant, user: current_user)
      redirect_to messages_path
    else
      render :new, status: :unprocessable_entity
    end
  end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------

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
