class CreateHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :histories do |t|
      t.integer :quantity
      t.datetime :expires_at
      t.references :house_ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
