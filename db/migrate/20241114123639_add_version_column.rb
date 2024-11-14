class AddVersionColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :version, :integer, default: 0, null: false
    add_column :chats, :version, :integer, default: 0, null: false
  end
end
