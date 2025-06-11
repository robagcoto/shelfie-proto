class Message < ApplicationRecord
  acts_as_message
  belongs_to :chat
  belongs_to :user
  validates :prompt, presence: true
  validates :role, presence: true


end
