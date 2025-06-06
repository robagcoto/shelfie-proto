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
        ok: !!(stock_quantity && stock_quantity >= recipe_ingredient.quantity)
      }
    end
  end
end
