class AddChatKeyToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :chat_key, :string
  end
end
