class Message < ApplicationRecord
  validates :sender_id, :recipient_id, :content, presence: true

  def self.from_all_senders(recipient_id, limit)
    if limit == "100"
      Message.where(recipient_id: recipient_id)
             .order('created_at DESC')
             .limit(limit)
    elsif limit == "30d"
      Message.where(recipient_id: recipient_id)
             .where('created_at >= ?', (DateTime.now - 30))
             .order('created_at DESC')
    end
  end

  def self.from_sender(recipient_id, sender_id, limit)
    if limit == "100"
      Message.where(recipient_id: recipient_id, sender_id: sender_id)
             .order('created_at DESC')
             .limit(limit)
    elsif limit == "30d"
      Message.where(recipient_id: recipient_id, sender_id: sender_id)
             .where('created_at >= ?', (DateTime.now - 30))
             .order('created_at DESC')
    end
  end
end
