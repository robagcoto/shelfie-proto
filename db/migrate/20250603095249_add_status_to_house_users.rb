class AddStatusToHouseUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :house_users, :status, :string, default: "pending"
  end
end
