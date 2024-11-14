class ApplicationsConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      action = message.payload[KafkaConstants::ACTION]
      token = message.payload[KafkaConstants::TOKEN]
      name = message.payload[KafkaConstants::NAME]
      
      case action
      when KafkaConstants::CREATE_ACTION
        app = Application.new(name: name, chats_count: 0, token: token)
        app.save
      end
    end
  end
end
