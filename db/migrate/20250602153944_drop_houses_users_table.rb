class DropHousesUsersTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :houses_users, if_exists: true
  end

  def down
    create_table :houses_users, id: false do |t|
      t.bigint :house_id, null: false
      t.bigint :user_id, null: false
      t.string :roles
    end
  end
end
