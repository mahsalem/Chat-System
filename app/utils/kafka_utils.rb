module KafkaUtils
  def self.sendKafkaMessage(topic, payload)
    Karafka.producer.produce_sync(topic: topic, payload: payload)
  end
  
  def self.sendApplicationKafkaMessage(action, token, name)
    payload = { KafkaConstants::ACTION => action, KafkaConstants::TOKEN => token, KafkaConstants::NAME => name }.to_json
    sendKafkaMessage(KafkaConstants::APPLICATION_TOPIC, payload)
  end

  def self.sendChatKafkaMessage(action, token, chat_number)
    payload = { KafkaConstants::ACTION => action, KafkaConstants::TOKEN => token, KafkaConstants::CHAT_NUMBER => chat_number }.to_json
    sendKafkaMessage(KafkaConstants::CHAT_TOPIC, payload)
  end

  def self.sendMessageKafkaMessage(action, token, chat_number, message_number, body)
    payload = { KafkaConstants::ACTION => action, KafkaConstants::TOKEN => token, KafkaConstants::CHAT_NUMBER => chat_number, KafkaConstants::MESSAGE_NUMBER => message_number, KafkaConstants::MESSAGE_CONTENT => body }.to_json
    sendKafkaMessage(KafkaConstants::MESSAGE_TOPIC, payload)
  end
end