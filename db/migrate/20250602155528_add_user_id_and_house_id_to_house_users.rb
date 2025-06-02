class AddUserIdAndHouseIdToHouseUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :house_users, :user, null: false, foreign_key: true
    add_reference :house_users, :house, null: false, foreign_key: true
  end
end
