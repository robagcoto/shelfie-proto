class House < ApplicationRecord
  has_many :house_users
  has_many :users, through: :house_users
  has_many :house_ingredients
end
