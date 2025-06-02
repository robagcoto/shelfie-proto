class DropCookbooksTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :cookbooks
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
