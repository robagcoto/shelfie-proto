class HomeController < ApplicationController
  def index
    @recipes = Recipe.all
    @house = House.default_for(current_user)
  end
end
