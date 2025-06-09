class AddStorageMethodToHouseIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :house_ingredients, :storage_method, :string
  end
end
