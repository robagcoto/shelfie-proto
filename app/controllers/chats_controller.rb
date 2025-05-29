class ChatsController < ApplicationController
  def index
     @chats =  current_user.chats
     @chat = Chat.new
  end
end
