class ChatsConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      action = message.payload[KafkaConstants::ACTION]
      token = message.payload[KafkaConstants::TOKEN]
      chat_number = message.payload[KafkaConstants::CHAT_NUMBER]

      chat_key = Chat.generate_key(token, chat_number)
      
      case action
      when KafkaConstants::CREATE_ACTION
        application = Application.find_by(token: token)
        application.chats_count = application.chats_count + 1
        application.save
        
        chat = Chat.create(application_id: application.id, messages_count: 0, number: chat_number, chat_key: chat_key)
      end
    end
  end
end
