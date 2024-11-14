class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy
  self.locking_column = :version

  INITIAL_CHAT_NUMBER = 1

  def self.generate_key(token, chat_number)
    "#{token}_#{chat_number}"
  end
end
