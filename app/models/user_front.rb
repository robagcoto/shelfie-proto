class UserFront < ApplicationRecord
  belongs_to :user
  belongs_to :front

  validates :user_id, presence: true
  validates :front_id, presence: true
end
