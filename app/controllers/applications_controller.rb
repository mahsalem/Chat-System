include KafkaUtils

class ApplicationsController < ApplicationController

  def create
    token = Application.generate_token
    $redis.set(token, Chat::INITIAL_CHAT_NUMBER)
    KafkaUtils.sendApplicationKafkaMessage(KafkaConstants::CREATE_ACTION, token, params[:name])
    render json: {application_token: token}, status: :ok
  end

  def show
    app = Application.find_by(token: params[:token])
    render json: app, except: :id, status: :ok
  end

  def update
    token = params[:token]
    if $redis.exists?(token)
      app = Application.find_by(token: token)
      app.name = params[:name]
      app.save # optimistic locking
      render json: {system_message: SystemMessages::APPLICATION_UPDATED_MESSAGE}, status: :ok
    else
      render json: {system_message: SystemMessages::INVALID_TOKEN_MESSAGE}, status: :not_found
    end
  end

  def destroy
    token = params[:token]
    if $redis.exists?(token)
      $redis.del(token)
      app = Application.find_by(token: token)
      app.destroy
      render json: {system_message: SystemMessages::APPLICATION_DELETED_MESSAGE}, status: :ok
    else
      render json: {system_message: SystemMessages::INVALID_TOKEN_MESSAGE}, status: :not_found
    end
  end
end
