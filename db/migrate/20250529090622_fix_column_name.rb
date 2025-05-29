class FixColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :ingredients_recipes, :quatity, :quantity
  end
end
