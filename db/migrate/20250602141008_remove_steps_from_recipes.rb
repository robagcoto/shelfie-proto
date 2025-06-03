class RemoveStepsFromRecipes < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipes, :steps, :text
  end
end
