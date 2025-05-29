class AddFavoritToNomRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :favorite, :boolean
  end
end
