class RemoveIngredientsFromRecipe < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipes, :ingredients, :string
  end
end
