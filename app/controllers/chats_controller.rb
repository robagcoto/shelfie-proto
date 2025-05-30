class ChatsController < ApplicationController

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
    @chats = Chat.where(user_id: current_user)
  end

  def new
    @chat = Chat.new
  end

  def create
    # Crée message utilisateur
    @chat = current_user.chats.new(title: "Untitled")
    if @chat.save
      prompt = params[:chat][:prompt]
      user_message = @chat.messages.create!(prompt: prompt, role: "user", user_id: current_user.id)

    #Génère le titre dès le démarrage
      @chat.generate_title_from_first_message

    #Lance LLM
      chat = RubyLLM.chat
      response = chat.with_instructions(instructions).ask(prompt)

    #Crée le message du assistant
      Message.create!(prompt: response.content, role: :assistant, user_id: current_user.id, chat_id: @chat.id)
      redirect_to  chat_messages_path(@chat)
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
