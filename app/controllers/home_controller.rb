class HomeController < ApplicationController
  def index
    @recipes = Recipe.all
    @house = House.default_for(current_user)
    @house_ingredients = @house.house_ingredients.order(:expiration_date)
  end
end
