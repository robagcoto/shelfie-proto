class AddNomDeLaColonneToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :my_recipe, :boolean
  end
end
