class History < ApplicationRecord
  belongs_to :house_ingredient
  has_many :histories,
           class_name: "HouseIngredientHistory",
           foreign_key: "house_ingredient_id",
           dependent: :destroy
end
