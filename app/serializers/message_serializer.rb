class MessageSerializer
  include JSONAPI::Serializer

  set_type :message
  attributes :sender_id, :recipient_id, :content, :created_at
end
