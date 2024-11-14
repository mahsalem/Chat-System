class MessagesConsumer < ApplicationConsumer
  def consume
    messages.each do |message| 
      action = message.payload[KafkaConstants::ACTION]
      token = message.payload[KafkaConstants::TOKEN]
      chat_number = message.payload[KafkaConstants::CHAT_NUMBER]
      message_number = message.payload[KafkaConstants::MESSAGE_NUMBER]
      body = message.payload[KafkaConstants::MESSAGE_CONTENT]

      chat_key = Chat.generate_key(token, chat_number)
      
      case action
      when KafkaConstants::CREATE_ACTION
        chat = Chat.find_by(chat_key: chat_key)
        chat.messages_count = chat.messages_count + 1
        chat.save

        Message.create(chat_id: chat.id, number: message_number, body: body, chat_key: chat_key)
      end
    end
  end
end