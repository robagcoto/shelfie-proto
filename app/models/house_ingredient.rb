class HouseIngredient < ApplicationRecord
  belongs_to :house
  belongs_to :ingredient
end
