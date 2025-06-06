class PagesController < ApplicationController
  def dashboard
    
    @favorite_recipes = Recipe.where(favorite: true)
  end
end
