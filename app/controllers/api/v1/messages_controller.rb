class Api::V1::MessagesController < ApplicationController
  def index
    recipient_id = params[:recipient_id]
    sender_id = params[:sender_id]
    limit = params[:limit]

    if recipient_id && sender_id && limit
      messages = Message.where(recipient_id: recipient_id, sender_id: sender_id)
               .order('created_at DESC')
               .limit(limit)
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
end