class ChangeDefaultForFavoriteInMessages < ActiveRecord::Migration[7.1]
  def change
    change_column_default :recipes, :favorite, false
  end
end
