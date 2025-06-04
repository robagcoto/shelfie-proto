class HouseIngredientsController < ApplicationController
  def index
    @house = House.find(params[:house_id])
    @house_ingredeints = @house.house_ingredients.includes(:ingredient)
  end
end
