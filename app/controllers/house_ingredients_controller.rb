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
    uploaded_io = params[:ticket_photo]
    if uploaded_io.blank?
      #message d'erreur si pas de photo valide, et retourne dans index
      redirect_to house_house_ingredients_path(@house), alert: "Invalid file"
      return
    end
    image_path = uploaded_io.tempfile.path
    #lance l'appel vers le LLM
    parsed_products = analyze_ticket_with_llm(image_path) #ATTENTION à VALIDER
    # Stocke temporairement le résultat pour l’utilisateur // session permet de stocker une donnée temporairement sans stocker dans db
    raise
    session[:parsed_products] = parsed_products
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

  def analyze_ticket_with_llm(image_path)
      system_prompt = <<~PROMPT
      You are an assistant for a food waste app.
      Here is a photo of a grocery receipt.
      Extract and return only food products (ignore other items).
      For each product:
      - Extract the name (normalize if needed, excluding brands). For example, if the line is "Lait Lactel", just return "milk".
      - Suggest the storage_method "dry", "fridge", or "freezer", based on the product type.
      - Categorize into one of the following: [Fruits, Vegetables, Bread, cereals, and nuts, Meats, Fish and seafood, Dairy and eggs, Legumes, Beverages, Sweets, Processed foods and ready meals].
      - Calculate the expiration_date based on the scanning date, which is the current date at the time of reading this prompt (An expiration date cannot be before today). Use typical shelf-life estimates for each product based on the storage_method.
      - Include the estimated quantity, and use "g", "l", or "pc(s)" as the unit (e.g., for packaged, loose, or liquid products).
      Return all in a JSON array, one object per food product. Ignore other items. Use these keys: "name", "storage_method", "category", "expiration_date", "quantity", and "unit".
      Use the supermarket name (if available on the receipt) to better understand how products and codes are represented.
    PROMPT

    #instancer un chat
    chat = RubyLLM.chat(
      model: "google/gemini-2.5-pro-preview",
      provider: 'openrouter',
      assume_model_exists: true
    )
    #Appel LLM
    response = chat.ask(system_prompt, with: image_path)
    JSON.parse(response.content)
  end


end
