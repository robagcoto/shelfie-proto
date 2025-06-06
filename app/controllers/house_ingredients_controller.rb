class HouseIngredientsController < ApplicationController
  # d'entrée nous définisons le house avec la méthode privée
  before_action :default_house

  def index
    # @house = House.default_for(current_user)
    @house_ingredients = @house.house_ingredients.includes(:ingredient)
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
    normalized_input = Ingredient.normalized_name(params[:house_ingredient][:ingredient_name])
    ingredient = Ingredient.all.find { |ing| Ingredient.normalized_name(ing.name) == normalized_input }
    exp_date = Date.new(
      params[:house_ingredient]["expiration_date(1i)"].to_i,
      params[:house_ingredient]["expiration_date(2i)"].to_i,
      params[:house_ingredient]["expiration_date(3i)"].to_i
    )

    if ingredient
      new_house_ingredient = HouseIngredient.create!(
        expiration_date: exp_date,
        quantity: params[:house_ingredient][:quantity],
        unit: params[:unit],
        house: @house,
        ingredient: ingredient
      )
      redirect_to house_house_ingredient_path(@house, new_house_ingredient)
    else

    end

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

  def house_ingredients_params
    params.require(:house_ingredient).permit(:ingredient_name, :quantity, :expiration_date)
  end
end
