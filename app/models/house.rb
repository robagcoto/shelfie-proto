class House < ApplicationRecord
  has_many :houses_users
  has_many :users, through: :houses_users
  has_many :house_ingredients
end
