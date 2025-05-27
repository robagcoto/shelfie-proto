class CreateCookbooks < ActiveRecord::Migration[7.1]
  def change
    create_table :cookbooks do |t|
      t.references :ingredient, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
