class RemoveQuantityFromRecipe < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipes, :quantity, :integer
  end
end
