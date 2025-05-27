class AddPromptSettingsColumnToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :prompt_setting, :string
  end
end
