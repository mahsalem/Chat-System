# frozen_string_literal: true

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = { 'bootstrap.servers': 'kafka:9092' }
    config.client_id = 'chat_system'
    # Recreate consumers with each batch. This will allow Rails code reload to work in the
    # development mode. Otherwise Karafka process would not be aware of code changes
    config.consumer_persistence = !Rails.env.development?
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(
    Karafka::Instrumentation::LoggerListener.new(
      # Karafka, when the logger is set to info, produces logs each time it polls data from an
      # internal messages queue. This can be extensive, so you can turn it off by setting below
      # to false.
      log_polling: true
    )
  )
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  # This logger prints the producer development info using the Karafka logger.
  # It is similar to the consumer logger listener but producer oriented.
  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(
      # Log producer operations using the Karafka logger
      Karafka.logger,
      # If you set this to true, logs will contain each message details
      # Please note, that this can be extensive
      log_messages: false
    )
  )

  # You can subscribe to all consumer related errors and record/track then that way
  #
  # Karafka.monitor.subscribe 'error.occurred' do |event|
  #   type = event[:type]
  #   error = event[:error]
  #   details = (error.backtrace || []).join("\n")
  #   ErrorTracker.send_error(error, type, details)
  # end

  # You can subscribe to all producer related errors and record/track then that way
  # Please note, that producer and consumer have their own notifications pipeline so you need to
  # setup error tracking independently for each of them
  #
  # Karafka.producer.monitor.subscribe('error.occurred') do |event|
  #   type = event[:type]
  #   error = event[:error]
  #   details = (error.backtrace || []).join("\n")
  #   ErrorTracker.send_error(error, type, details)
  # end

  routes.draw do
    topic KafkaConstants::APPLICATION_TOPIC do
      consumer ApplicationsConsumer
    end

    topic KafkaConstants::CHAT_TOPIC do
      consumer ChatsConsumer
    end

    topic KafkaConstants::MESSAGE_TOPIC do
      consumer MessagesConsumer
    end
  end
end

# Karafka now features a Web UI!
# Visit the setup documentation to get started and enhance your experience.
#
# https://karafka.io/docs/Web-UI-Getting-Started