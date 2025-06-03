class Message < ApplicationRecord
  # acts_as_message
  belongs_to :chat
  validates :prompt, presence: true
  validates :role, presence: true
end
