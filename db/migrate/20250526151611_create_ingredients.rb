class CreateIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :quantity
      t.string :unit_type
      t.string :food_type
      t.string :storage_type
      t.date :purchase_date
      t.date :best_before_date

      t.timestamps
    end
  end
end
