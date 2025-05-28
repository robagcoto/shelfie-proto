class PagesController < ApplicationController
  def dashboard
    @my_recipes = Recipe.where(user_id: current_user)
  end
end
