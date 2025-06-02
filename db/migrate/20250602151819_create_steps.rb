class CreateSteps < ActiveRecord::Migration[7.1]
  def change
    create_table :steps do |t|
      t.string :description
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
