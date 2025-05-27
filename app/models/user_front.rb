class UserFront < ApplicationRecord
  has_many :cookbooks
  has_many :ingredients, through: :cookbooks
  has_many :recipes, through: :cookbooks

  validates :user_id, presence: true
  validates :email_id, presence: true, uniqueness: true
  validates :password_id, presence: true
end
