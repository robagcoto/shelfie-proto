class Ingredient < ApplicationRecord
#   UNIT_TYPES = [
#   "g",
#   "l",
#   "cup",
#   "tbsp",
#   "tsp",
#   "piece"
# ]

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
    "Processed foods and ready meals",
]

STORAGE_METHODS = [
  "Dry",
  "Fridge",
  "Freezer"
]

#   validates :name, presence: true
#   validates :quantity, presence: true
#   validates :unit_type, presence: true, inclusion: { in: UNIT_TYPES }
#   validates :food_type, presence: true, inclusion: { in: FOOD_TYPES }

has_many :house_ingredients
validates :storage_method, presence: true, inclusion: { in: STORAGE_METHODS }
validates :category, presence: true, inclusion: { in: CATEGORIES }

end
