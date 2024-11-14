class ChatsController < ApplicationController

  def index
    token = params[:application_token]
    if $redis.exists?(token)
      application = Application.find_by(token: params[:application_token]) # check if application exists
      chats = Chat.where(application_id: application.id)
      render json: chats, except: [:id, :application_id, :chat_key], status: :ok
    else
      render json: {system_message: SystemMessages::INVALID_TOKEN_MESSAGE}, status: :not_found
    end
  end

  def create
    token = params[:application_token]
    if $redis.exists?(token)
      chat_number = $redis.get(token) # lock redis
      $redis.incr(token)
      $redis.set(Chat.generate_key(token, chat_number), Message::INITIAL_MESSAGE_NUMBER)
      KafkaUtils.sendChatKafkaMessage(KafkaConstants::CREATE_ACTION, token, chat_number)
      render json: {chat_number: chat_number}, status: :ok
    else
      render json: {system_message: SystemMessages::INVALID_TOKEN_MESSAGE}, status: :not_found
    end
  end

  def show
    token = params[:application_token]
    if $redis.exists?(token)
      chat_number = params[:number]
      application = Application.find_by(token: token)
      chat = Chat.find_by(application_id: application.id, number: chat_number)
      if chat != nil
        render json: chat.to_json(include: {:messages => {except: [:id, :chat_id, :chat_key]}}, except: [:id, :application_id, :chat_key]), status: :ok
      else
        render json: {system_message: SystemMessages::INVALID_CHAT_NUMBER_MESSAGE}, status: :not_found
      end
    else
      render json: {system_message: SystemMessages::INVALID_TOKEN_MESSAGE}, status: :not_found
    end
  end

  def destroy
    token = params[:application_token]
    if $redis.exists?(token)
      chat_number = params[:number]
      chat_key = Chat.generate_key(token, chat_number)
      if $redis.exists?(chat_key)
        application = Application.find_by(token: token)
        application.chats_count = application.chats_count - 1
        application.save

        chat = Chat.find_by(chat_key: chat_key)
        chat.destroy
        render json: {system_message: SystemMessages::CHAT_DELETED_MESSAGE}, status: :ok
      else
        render json: {system_message: SystemMessages::INVALID_CHAT_NUMBER_MESSAGE}, status: :not_found
      end
    else
      render json: {system_message: SystemMessages::INVALID_TOKEN_MESSAGE}, status: :not_found
    end
  end

  def search
    query = params[:query]
    page_size = params[:page_size]
    page = params[:page]
    chat_key = Chat.generate_key(params[:application_token], params[:chat_number])
    messages = Message.search(query, chat_key, page_size, page).records
    render json: messages, except: [:id, :chat_id, :chat_key], status: :ok
  end
end
