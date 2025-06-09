class HouseIngredient < ApplicationRecord
  attr_accessor :ingredient_name

  VALID_CATEGORIES = ['l', 'g', 'pc(s)']

  belongs_to :house
  belongs_to :ingredient
  validates :unit, presence: true, inclusion: { in: VALID_CATEGORIES }

  has_many :histories,
           class_name: "History",
           foreign_key: "house_ingredient_id",
           dependent: :destroy
end
