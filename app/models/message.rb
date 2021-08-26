class Message < ApplicationRecord
  validates :sender_id, :recipient_id, :content, presence: true
end
