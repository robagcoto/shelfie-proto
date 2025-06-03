class AddNumberOfIngredientsToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :number_of_ingredients, :integer
  end
end
