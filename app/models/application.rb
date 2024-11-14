class Application < ApplicationRecord
  has_many :chats, dependent: :destroy
  self.locking_column = :version

  def self.generate_token
    loop do
      token = SecureRandom.hex(16)
      break token if $redis.exists(token)
    end
  end
end
