class PagesController < ApplicationController
  def dashboard
    @my_recipes = Recipe.where(user_id: current_user)
    @favorite_recipes = Recipe.where(favorite: true)
  end
end
