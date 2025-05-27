class AddQuantityToRecipe < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :quantity, :integer
  end
end
