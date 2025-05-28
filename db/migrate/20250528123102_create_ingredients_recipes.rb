class CreateIngredientsRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredients_recipes do |t|
      t.string :name
      t.integer :quatity
      t.string :unit
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
