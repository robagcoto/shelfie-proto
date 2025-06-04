class Ingredient < ApplicationRecord
#   UNIT_TYPES = [
#   "g",
#   "l",
#   "cup",
#   "tbsp",
#   "tsp",
#   "piece"
# ]

# FOOD_TYPES = [
#   "vegetable",
#   "fruit",
#   "meat",
#   "fish",
#   "dairy",
#   "grain",
#   "spice",
#   "condiment",
#   "beverage",
#   "sweet",
#   "frozen",
#   "prepared",
#   "other"
# ]

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

end
