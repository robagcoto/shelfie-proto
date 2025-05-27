class MessagesController < ApplicationController

  SYSTEM_PROMPT = "
  You are a creative professional chef assistant.
  "

  def index
  end

  def new
    @message = Message.new
  end

  def create

  end
end
