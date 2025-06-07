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
    #je normalize le inout de l'utilisateur. La méthode est dans le modèle Ingredient (Strip, singularize et downcase)
    normalized_input = Ingredient.normalized_name(params[:house_ingredient][:ingredient_name])
    #je vérifie dans la rable ingredient l'unicité de l'ingrédient en comparant le nom et le storage_method
    ingredient = Ingredient.all.find do |ing|
      Ingredient.normalized_name(ing.name) == normalized_input &&
      ing.storage_method == params[:storage_method]
    end
    #je recompose la DLC
    exp_date = Date.new(
      params[:house_ingredient]["expiration_date(1i)"].to_i,
      params[:house_ingredient]["expiration_date(2i)"].to_i,
      params[:house_ingredient]["expiration_date(3i)"].to_i
    )
    #je vérifie si l'ingredient existe, s'il existe je créé uniquement le HouseIngredient
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
      # si'l n'existe pas, je créé d'abord l'Ingredient puis le HouseIngredient
      new_ingredient = Ingredient.create!(
        name: Ingredient.normalized_name(params[:house_ingredient][:ingredient_name]),
        storage_method: params[:storage_method],
        category: params[:category]
      )

      new_house_ingredient = HouseIngredient.create!(
        expiration_date: exp_date,
        quantity: params[:house_ingredient][:quantity],
        unit: params[:unit],
        house: @house,
        ingredient: new_ingredient
      )
      redirect_to house_house_ingredient_path(@house, new_house_ingredient)
    end
  end

  def edit

  end

  def update

  end

  def destroy
    @house_ingredient = HouseIngredient.find(params[:id])
    @house_ingredient.destroy
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
