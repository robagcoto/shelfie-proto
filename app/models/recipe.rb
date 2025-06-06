class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients_recipes, dependent: :destroy
  has_many :completions, dependent: :destroy
  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank

VALID_CATEGORIES = [
  'French',
  'Italian',
  'Japanese',
  'Mexican',
  'Indian',
  'Chinese',
  'Thai',
  'Greek',
  'Spanish',
  'Moroccan',
  'American',
  'Vietnamese',
  'Lebanese',
  'Korean',
  'Turkish'
]

  has_one_attached :photo
  validates :name, presence: true
  validates :description, presence: true
  validates :duration, presence: true
  # validates :category, presence: true, inclusion: { in: VALID_CATEGORIES }
  validates :rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5,
    allow_nil: true
  }
end
