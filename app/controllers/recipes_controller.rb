class RecipesController < ApplicationController
  # before_action :set_recipe, only: [:show, :destroy, :edit, :update, :new]

  def index
    @my_recipes = Recipe.where(user_id: current_user, my_recipe: true)
    @favorite_recipes = Recipe.where(favorite: true)
  end

  def show
    @recipe = Recipe.find(params[:id])

    #@ingredient_name = @recipe.ingredients_recipes.pluck(:name)


  end

  def new
    @recipe = Recipe.new
    @recipe.steps.build
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    @recipe.my_recipe = true
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
      Completion.create(recipe: @recipe)
      # soustraire les ingredients de ma recette (leur quantité)
      # à ceux que j'ai dans mon frigo
      redirect_to recipe_path
    else
      render :edit
    end
  end

    # /:recipe_id
    def update_favorite
      raise
      # je récupère mon instance de recipe
      @recipe = Recipe.find(params[:id])

      # instance.update(favorite: !instance.favorite)
      @recipe.update(favorite: @recipe.favorite)

      # si .favorite == false => je l'update en true
      # si .favorite == true => je l'update en false
      if @recipe.favorite == false
        @recipe.update(favorite: true)
      else
        @recipe == true
        @recipe.update(favorite: false)
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
    params.require(:recipe).permit(:name, :photo, :description, :category, :duration, :favorite, :rating, :number_of_ingredients, steps_attributes: [:id, :description])
  end

  def ingredients_recipe
    params.require(:ingredients_recipe).permit(:name, :quantity, :unit)
  end

end
