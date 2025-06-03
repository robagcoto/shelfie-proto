class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :description
      t.integer :rating
      t.string :category
      t.string :duration
      t.boolean :favorite, default: false
      t.integer :number_of_ingredients
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
