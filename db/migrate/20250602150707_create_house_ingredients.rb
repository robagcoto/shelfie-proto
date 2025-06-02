class CreateHouseIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :house_ingredients do |t|
      t.date :expiration_date
      t.integer :quantity
      t.string :unit
      t.references :house, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
