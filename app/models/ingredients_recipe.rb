class IngredientsRecipe < ApplicationRecord
  belongs_to :recipe

  VALID_CATEGORIES = ['l', 'g', 'pc(s)']

  validates :name, presence: true
  validates :quantity, presence: true
  validates :unit, presence: true, inclusion: { in: VALID_CATEGORIES }
end
