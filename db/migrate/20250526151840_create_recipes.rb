class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :description
      t.integer :rating
      t.string :ingredients
      t.string :category

      t.timestamps
    end
  end
end
