class AddRolesToHousesUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :houses_users, :roles, :string
  end
end
