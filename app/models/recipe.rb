class Recipe < ApplicationRecord
  has_many :ingredients, through: :cookbook
  belongs_to :user
  VALID_CATEGORIES = ['French', 'Italian', 'Japanese', 'Mexican', 'Indian']

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
