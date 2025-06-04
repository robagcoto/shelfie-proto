class CreateHouseUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :house_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :house, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
