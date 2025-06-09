class Ingredient < ApplicationRecord

  CATEGORIES = [
      "Fruits",
      "Vegetables",
      "Bread, cereals, and nuts",
      "Meats",
      "Fish and seafood",
      "Dairy and eggs",
      "Legumes",
      "Beverages",
      "Sweets",
      "Processed foods and ready meals"
  ]

  STORAGE_METHODS = [
    "Dry",
    "Fridge",
    "Freezer"
  ]

  has_one_attached :photo
  has_many :house_ingredients
  validates :storage_method, presence: true, inclusion: { in: STORAGE_METHODS }
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  def self.normalized_name(name)
    name.to_s.strip.downcase.singularize
  end
end
