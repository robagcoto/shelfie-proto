class Ingredient < ApplicationRecord
  UNIT_TYPES = [
  "g",
  "l",
  "cup",
  "tbsp",
  "tsp",
  "piece"
]

FOOD_TYPES = [
  "vegetable",
  "fruit",
  "meat",
  "fish",
  "dairy",
  "grain",
  "spice",
  "condiment",
  "beverage",
  "sweet",
  "frozen",
  "prepared",
  "other"
]

STORAGE_TYPES = [
  "dry",
  "fridge",
  "freezer",
]
  validates :name, presence: true
  validates :quantity, presence: true
  validates :unit_type, presence: true, inclusion: { in: UNIT_TYPES }
  validates :food_type, presence: true, inclusion: { in: FOOD_TYPES }
  validates :storage_type, presence: true, inclusion: { in: STORAGE_TYPES}
end
