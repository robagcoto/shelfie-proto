class Message < ApplicationRecord
  belongs_to :chat
  validates :prompt, presence: true
  validates :role, presence: true
end
