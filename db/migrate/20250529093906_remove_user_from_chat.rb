class RemoveUserFromChat < ActiveRecord::Migration[7.1]
  def change
    remove_reference :chats, :user, null: false, foreign_key: true
  end
end
