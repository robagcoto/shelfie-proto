class Chat < ApplicationRecord
  attr_accessor :prompt

  belongs_to :user
  has_many :messages, dependent: :destroy
end
