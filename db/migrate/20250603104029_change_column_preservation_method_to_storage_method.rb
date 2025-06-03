class ChangeColumnPreservationMethodToStorageMethod < ActiveRecord::Migration[7.1]
  def change
    rename_column :ingredients, :preservation_method, :storage_method
  end
end
