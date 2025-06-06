class HouseIngredientsController < ApplicationController
  # d'entrée nous définisons le house avec la méthode privée
  before_action :default_house

  def index
    # @house = House.default_for(current_user)
    @house_ingredients = @house.house_ingredients.includes(:ingredient)

    if params[:category].present? && params[:category] != "All"
      @house_ingredients = @house_ingredients
      .joins(:ingredient)
      .where(ingredients: { category: params[:category] })
    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
    # format.html
  end

  # Les utilisateurs ne pourront pas crééer directement d'ingrédients dans la table ingrédients, uniquement ici
  def new
    # appeler la house dans laquelle on est  /// déjà fait en private
    # Crééer une nouvelle instance de house_ingredients // diff approche de HouseIngredient.new car celle-ci créé la relation auto avec la house
    @house_ingredient = @house.house_ingredients.new
    # Lister tous les ingredients au cas où on met une logique d'autocompletion
    @ingredients = Ingredient.all
  end

  def show
    @house_ingredient = HouseIngredient.find(params[:id])
  end

  def create
    @house_ingredient = IngredientHouse.new
  end

  def edit

  end

  def update
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy
    redirect_to house_house_ingredients_path(@house), notice: "Hasta la vista, baby..."
  end

private

  def default_house
    @house = House.default_for(current_user)
  end
end
