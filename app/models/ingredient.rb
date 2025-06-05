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
    "fruits",
    "vegetables",
    "bread, cereals, and nuts",
    "meats",
    "fish and seafood",
    "dairy and eggs",
    "legumes",
    "beverages",
    "sweets",
    "processed foods and ready meals",
]

STORAGE_METHODS = [
  "dry",
  "fridge",
  "freezer"
]

#   validates :name, presence: true
#   validates :quantity, presence: true
#   validates :unit_type, presence: true, inclusion: { in: UNIT_TYPES }
#   validates :food_type, presence: true, inclusion: { in: FOOD_TYPES }

has_many :house_ingredients
validates :storage_method, presence: true, inclusion: { in: STORAGE_METHODS }
validates :category, presence: true, inclusion: { in: CATEGORIES }

end
