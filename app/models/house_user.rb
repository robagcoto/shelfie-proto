class HouseUser < ApplicationRecord
  ROLES = ["admin", "user", "guest"]
  STATUSES = ["pending", "accepted", "declined"]

  belongs_to :house
  belongs_to :user
  validates :roles, presence: true, inclusion: { in: ROLES }
  validates :status, presence: true, inclusion: { in: STATUSES }
end
