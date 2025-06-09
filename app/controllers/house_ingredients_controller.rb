class HouseIngredientsController < ApplicationController
  before_action :default_house
  require 'net/http'
  require 'json'
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
      name:         Ingredient.normalized_name(params[:house_ingredient][:ingredient_name]),
      storage_method: house_ingredient_params[:storage_method]
    )
    unless ing
      ing = Ingredient.create!(
        name:           params[:house_ingredient][:ingredient_name],
        storage_method: house_ingredient_params[:storage_method],
        category:       @house_ingredient.ingredient.category
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

  def analyze_ticket
    #récupère photo, on appelle le paramettre ticket_photo.. aligné avec ce que j'ai mis dans le boutton form
    image_data = params[:ticket_photo]
    if image_data.blank?
      #message d'erreur si pas de photo valide, et retourne dans index
      redirect_to house_house_ingredients_path(@house), alert: "Invalid file"
      return
    end
    #lance l'appel vers mon LLM
    parsed_products = analyze_ticket_with_llm(image_data) #ATTENTION à VALIDER
    # Stocke temporairement le résultat pour l’utilisateur // session permet de stocker une donnée temporairement sans stocker dans db
    session[:parsed_products] = parsed_products
    raise
    #rediriger vers page d'édition /// a coder après
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

  def analyze_ticket_with_llm(image_data)
      prompt = <<~PROMPT
    You are an assistant for a food waste app.
    Here is a photo of a grocery receipt.
    Extract and return only food products (ignore other items).
    For each product, return:
    - name (normalize if needed)
    - estimated storage_method ("dry", "fridge", or "freezer", based on product type)
    - category (pick from: [Fruits, Vegetables, Bread, cereals, and nuts, Meats, Fish and seafood, Dairy and eggs, Legumes, Beverages, Sweets, Processed foods and ready meals])
    - estimated expiration_date (suggested typical date)
    - quantity and unit (unit = 'g', 'l', or 'pc(s)')
    Return all in a JSON array, one object per food product. Ignore other items.
  PROMPT

  #instancer un chat
  chat = RubyLLM.chat(model: "gpt-4o")
  #Appel LLM
  response = chat.ask(prompt, with: image_data.tempfile)

  begin
    JSON.parse(response.content)
    rescue JSON::ParserError => e
      Rails.logger.error("Erreur parsing LLM: #{e.message}")
      []
    end
  end

end
