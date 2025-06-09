class Message < ApplicationRecord
  acts_as_message
  belongs_to :chat
  belongs_to :user
  validates :prompt, presence: true
  validates :role, presence: true

  def dlc
    critical_ingredients = HouseIngredient
      .where(house: current_user.houses)
      .where.not(expiration_date: nil)
      .order(:expiration_date)
      .limit(5)

    ingredient_list = critical_ingredients.map do |hi|
      "#{hi.quantity} #{hi.unit} de #{hi.ingredient.name} (DLC: #{hi.expiration_date})"
    end.join(", ")
  end
end
