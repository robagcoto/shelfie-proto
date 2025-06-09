class HouseIngredientsController < ApplicationController
  before_action :default_house
  before_action :set_house_ingredient, only: %i[show edit update destroy]

  def index
    if params[:storage_method].present?
      @house_ingredients = HouseIngredient.joins(:ingredient).where(ingredients: { storage_method: params[:storage_method] })
    else
      @house_ingredients = HouseIngredient.all
    end

    if params[:category].present? && params[:category] != "All"
      @house_ingredients = @house_ingredients
      .joins(:ingredient)
      .where(ingredients: { category: params[:category] })
    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def new
    @house_ingredient = @house.house_ingredients.new
    @ingredients = Ingredient.all
  end

  def show
    logger.debug "StorageMethod = #{@house_ingredient.storage_method.inspect}"
  end

  def create
    @house_ingredient = @house.house_ingredients.new(house_ingredient_params)

    ing = Ingredient.find_by(
      name: Ingredient.normalized_name(params[:house_ingredient][:ingredient_name]),
      storage_method: house_ingredient_params[:storage_method]
    )
    unless ing
      ing = Ingredient.create!(
        name: params[:house_ingredient][:ingredient_name],
        storage_method: house_ingredient_params[:storage_method],
        category: @house_ingredient.ingredient.category
      )
    end

    @house_ingredient.ingredient = ing

    if @house_ingredient.save
      redirect_to house_house_ingredient_path(@house, @house_ingredient)
    else
      render :new
    end
  end

  def edit
  end

  def update
    # on met à jour le HouseIngredient (quantity & expiration_date)
    if @house_ingredient.update(house_ingredient_params.except(:storage_method))
      # puis on met à jour le storage_method sur l’Ingredient associé
      @house_ingredient.ingredient.update!(storage_method: house_ingredient_params[:storage_method])
      redirect_to house_house_ingredient_path(@house, @house_ingredient)
    else
      render :edit
    end
  end

  def destroy
    @house_ingredient.destroy
    redirect_to house_house_ingredients_path(@house), notice: "Hasta la vista, baby..."
  end

private

  def default_house
    @house = House.default_for(current_user)
  end

  def set_house_ingredient
    @house_ingredient = @house.house_ingredients.find(params[:id])
  end

  def house_ingredient_params
    params.require(:house_ingredient)
          .permit(:quantity, :expiration_date, :storage_method)
  end
end
