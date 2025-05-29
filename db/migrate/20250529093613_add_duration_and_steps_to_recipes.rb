class AddDurationAndStepsToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :duration, :string
    add_column :recipes, :steps, :text
  end
end
