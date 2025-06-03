class CreateJoinTableHousesUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :houses, :users do |t|
      # t.index [:house_id, :user_id]
      # t.index [:user_id, :house_id]
    end
  end
end
