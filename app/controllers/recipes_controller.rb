class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :destroy]

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(list_params)
    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipe_path, status: :see_other
  end

 private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :photo, :ingredients, :description)
  end
  
end
