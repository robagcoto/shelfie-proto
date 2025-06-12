class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_default_house

  def set_default_house
    @house = current_user.houses.first if user_signed_in?
  end

def default_url_options
  { host: ENV["DOMAIN"] || "localhost:3000" }
end
end
