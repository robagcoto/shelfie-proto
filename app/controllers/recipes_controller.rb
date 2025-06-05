class RecipesController < ApplicationController
  # before_action :set_recipe, only: [:show, :destroy, :edit, :update, :new]

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    @recipe.steps.build
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    counter = 1
    if @recipe.save
      number_of_ingredients = @recipe.number_of_ingredients
      number_of_ingredients.times do
        IngredientsRecipe.create(
          recipe_id: @recipe.id,
          name: params["ingredient_name#{counter}"],
          quantity: params["ingredient_quantity#{counter}"],
          unit: params["ingredient_unit#{counter}"]
    )
    counter += 1
    puts "counter: #{counter}"
    end
      redirect_to recipe_path(@recipe)
    else
      render :new, status: :unprocessable_entity
    end
  end

    def edit
      @recipe = Recipe.find(params[:id])
    end

    def update
      @recipe = Recipe.find(params[:id])
      if @recipe.update(recipe_params)
        redirect_to recipe_path
      else
        render :edit
      end
    end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipe_path, status: :see_other
  end

 private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :photo, :description, :category, :duration, :steps, :favorite, :rating, :number_of_ingredients, steps_attributes: [:id, :description])
  end

  def ingredients_recipe
    params.require(:ingredients_recipe).permit(:name, :quantity, :unit)
  end

end
