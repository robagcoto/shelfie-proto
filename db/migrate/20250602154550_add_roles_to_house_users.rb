class AddRolesToHouseUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :house_users, :roles, :string
  end
end
