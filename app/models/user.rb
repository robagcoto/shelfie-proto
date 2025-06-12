class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes
  has_many :chats, dependent: :destroy
  has_many :messages, through: :chat
  has_many :house_users, dependent: :destroy
  has_many :houses, through: :house_users

  def expiring_ingredients
    house = houses.first
    return [] unless house

    Ingredient.joins(:house_ingredients)
      .where(house_ingredients: { house_id: house.id })
      .where.not(house_ingredients: {expiration_date: nil})
      .order("house_ingredients.expiration_date ASC")
      .limit(5)
  end
end
