class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients_recipe

  VALID_CATEGORIES = ['French', 'Italian', 'Japanese', 'Mexican', 'Indian']
  has_one_attached :photo
  validates :name, presence: true
  validates :description, presence: true
  validates :ingredients, presence: true
  validates :category, presence: true, inclusion: { in: VALID_CATEGORIES }
  validates :quantity, presence: true
  validates :rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5,
    allow_nil: true
  }
end
