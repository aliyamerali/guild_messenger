class Api::V1::MessagesController < ApplicationController
  def index
    recipient_id = params[:recipient_id]
    sender_id = params[:sender_id]
    limit = params[:limit]

    if sender_id && valid_recipient_id?(recipient_id) && valid_limit?(limit)
      messages = Message.from_sender(recipient_id, sender_id, limit)
      render json: MessageSerializer.new(messages)
    elsif valid_recipient_id?(recipient_id) && valid_limit?(limit)
      messages = Message.from_all_senders(recipient_id, limit)
      render json: MessageSerializer.new(messages)
    else
      render json: { response: 'Bad Request'}, status: :bad_request
    end
  end

  def create
    new_message = Message.create(message_params)
    if new_message.save
      render json: { response: 'Created' }, status: :created
    else
      render json: { response: 'Bad Request'}, status: :bad_request
    end
  end

  private

  def message_params
    params.permit(:sender_id, :recipient_id, :content)
  end

  def valid_limit?(limit)
    limit == "100" || "30d"
  end

  def valid_recipient_id?(recipient_id)
    recipient_id.to_i != 0
  end
end
