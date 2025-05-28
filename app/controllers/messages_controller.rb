class MessagesController < ApplicationController

  SYSTEM_PROMPT = "
  You are a consice professional chef assistant.
  Please provide a recipe to our user.
  The recipe must contain: A description, a list of ingredients, an estimated duration of preparation and a step by step.
  Your responses are going to be in english even if part of the prompt is in a different language
  "

  def index
    @messages = current_user.messages
  end

  def new
    @message = current_user.messages.new
  end

  def create
    @message = current_user.messages.new(message_params.merge(role: :user))
    if @message.save
      chat = RubyLLM.chat
      response = chat.with_instructions(instructions).ask(@message.prompt)
      Message.create(prompt: response.prompt, role: :assistant, user: current_user)
      redirect_to messages_path
    else
      render :new, status: :unprocessable_entity
    end
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
