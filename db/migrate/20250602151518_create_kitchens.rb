class CreateKitchens < ActiveRecord::Migration[7.1]
  def change
    create_table :kitchens do |t|
      t.boolean :done
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
