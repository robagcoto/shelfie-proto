class CreateHouseUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :house_users do |t|

      t.timestamps
    end
  end
end
