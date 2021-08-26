class Api::V1::MessagesController < ApplicationController
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
