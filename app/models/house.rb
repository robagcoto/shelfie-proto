class House < ApplicationRecord

  has_many :house_users, dependent: :destroy
  has_many :users, through: :house_users
  has_many :house_ingredients, dependent: :destroy

  def self.default_for(user)
    user&.houses&.first
  end
end
