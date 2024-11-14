class AddChatKeyToChats < ActiveRecord::Migration[7.0]
  def change
    add_column :chats, :chat_key, :string
    add_index :chats, :chat_key, unique: true
  end
end
