class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients_recipes, dependent: :destroy
  has_many :completions, dependent: :destroy
  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank

VALID_CATEGORIES = [
  'French',
  'Italian',
  'Japanese',
  'Mexican',
  'Indian',
  'Chinese',
  'Thai',
  'Greek',
  'Spanish',
  'Moroccan',
  'American',
  'Vietnamese',
  'Lebanese',
  'Korean',
  'Turkish'
]


  has_one_attached :photo
  validates :name, presence: true
  validates :description, presence: true
  validates :duration, presence: true
  # validates :category, presence: true, inclusion: { in: VALID_CATEGORIES }
  validates :rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5,
    allow_nil: true
  }

  def ingredient_availability_for(house)
    stock = house.house_ingredients.joins(:ingredient)
      .pluck("ingredients.name", :unit, :quantity)
      .each_with_object({}) do |(name, unit, quantity), hash|
        hash[[name.downcase.strip, unit.downcase.strip]] = quantity
      end
    self.ingredients_recipes.map do |recipe_ingredient|
      key = [recipe_ingredient.name.downcase.strip, recipe_ingredient.unit.downcase.strip]
      stock_quantity = stock[key]
      {
        name: recipe_ingredient.name,
        ok: (stock_quantity && stock_quantity >= recipe_ingredient.quantity) ? true : false,
        # ok:
        quantity: recipe_ingredient.quantity,
        unit: recipe_ingredient.unit
      }
    end
  end
  def ingredients_fully_available_for?(house)
    stock = house.house_ingredients.joins(:ingredient)
      .pluck("ingredients.name", :unit, :quantity)
      .each_with_object({}) do |(name, unit, quantity), hash|
        hash[[name.downcase.strip, unit.downcase.strip]] = quantity
      end

    self.ingredients_recipes.all? do |recipe_ingredient|
      key = [
        recipe_ingredient.name.downcase.strip,
        recipe_ingredient.unit.downcase.strip
      ]
      stock_quantity = stock[key]
      stock_quantity && stock_quantity >= recipe_ingredient.quantity
    end
  end

  def decrement_house_ingredients!(house)
    # On utilise la méthode existante pour récupérer l'état de disponibilité des ingrédients
    availability = ingredient_availability_for(house)

    availability.each do |item|
      name = item[:name].downcase.strip
      quantity_needed = item[:quantity]
      unit = self.ingredients_recipes.find { |ri| ri.name.downcase.strip == name }.unit.downcase.strip

      # house_ingredient = house.house_ingredients.joins(:ingredient)
        # .find_by("LOWER(ingredients.name) = ? AND LOWER(house_ingredients.unit) = ?", name, unit)
      ingredient = Ingredient.find_by(name: name)
      house_ingredient = house.house_ingredients.find_by(ingredient: ingredient)
      next unless house_ingredient # L'ingrédient n'existe pas dans la maison, on passe
      if item[:ok]
        # Si on a assez, on décrémente
        house_ingredient.quantity -= quantity_needed
      else
        # Pas assez : on met à zéro
        house_ingredient.quantity = 0
      end
      house_ingredient.save!
    end
  end

end
