class MessagesController < ApplicationController
  def index
    if is_valid_request
      messages = Message.where(chat_key: @chat_key)
      render json: messages, except: [:id, :chat_id, :chat_key], status: :ok
    end
  end
  
  def create
    if is_valid_request
      @message_number = $redis.get(@chat_key)
      $redis.incr(@chat_key)
      KafkaUtils.sendMessageKafkaMessage(KafkaConstants::CREATE_ACTION, @token, @chat_number, @message_number, @body)
      render json: {message_number: @message_number}, status: :ok
    end
  end

  def show
    if is_valid_request
      render json: @message, except: [:id, :chat_id, :chat_key], status: :ok
    end
  end

  def update
    if is_valid_request
      message = Message.find_by(chat_key: @chat_key, number: @message_number)
      message.body = @body
      message.save
    render json: {system_message: SystemMessages::MESSAGE_UPDATED_MESSAGE}, status: :not_found
    end
  end

  def destroy
    if is_valid_request
      chat = Chat.find_by(chat_key: @chat_key)
      chat.messages_count = chat.messages_count - 1
      chat.save
      
      message = Message.find_by(chat_key: @chat_key, number: @message_number)
      message.destroy
    render json: {system_message: SystemMessages::MESSAGE_DELETED_MESSAGE}, status: :not_found
    end
  end

  def is_valid_request
    @token = params[:application_token]
    unless $redis.exists?(@token)
      render json: {system_message: SystemMessages::INVALID_TOKEN_MESSAGE}, status: :not_found
      return false
    end

    @chat_number = params[:chat_number]
    @chat_key = Chat.generate_key(@token, @chat_number)
    unless $redis.exists?(@chat_key)
      render json: {system_message: SystemMessages::INVALID_CHAT_NUMBER_MESSAGE}, status: :not_found
      return false
    end

    if @message_number = params[:number]
      unless @message = Message.find_by(chat_key: @chat_key, number: @message_number)
        render json: {system_message: SystemMessages::INVALID_MESSAGE_NUMBER_MESSAGE}, status: :not_found
        return false
      end
    end
      
    @body = params[:body]
    return true
  end
end
