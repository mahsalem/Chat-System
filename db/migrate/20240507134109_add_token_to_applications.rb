class AddTokenToApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :token, :string, limit: 32
    add_index :applications, :token, unique: true
  end
end
