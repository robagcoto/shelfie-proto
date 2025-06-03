class CreateCompletions < ActiveRecord::Migration[7.1]
  def change
    create_table :completions do |t|
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
