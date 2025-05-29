class ChatsController < ApplicationController
  def index
    @chats = Chat.where(user_id: current_user)
  end
end
