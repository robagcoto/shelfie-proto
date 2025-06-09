class Chat < ApplicationRecord
  acts_as_chat

  attr_accessor :prompt

  belongs_to :user
  has_many :messages, dependent: :destroy

  TITLE_PROMPT = <<~PROMPT
    Generate a short, descriptive, 3-to-6-word title that summarizes the user question for a chat conversation.
  PROMPT

  def generate_title_from_first_message
    return unless title == "Untitled"

    first_user_message = messages.where(role: "user").order(:created_at).first
    return if first_user_message.nil?

    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(first_user_message.prompt)
    update(title: response.content)
  end
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
