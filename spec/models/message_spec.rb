require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it {should validate_presence_of(:sender_id)}
    it {should validate_presence_of(:recipient_id)}
    it {should validate_presence_of(:content)}
  end

  describe 'class methods' do
    before :each do
      @recipient_id = 1234
      @sender_a_id = 5678
      @sender_b_id = 9999

      # 75 messages from sender A within 120 days
      75.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_a_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2020,5,01)
                      )
      end

      # 25 messages from sender A within 60 days
      25.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_a_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2020,7,01)
                      )
      end

      # 25 messages from sender A within 30 days
      25.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_a_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2020,8,15)
                      )
      end

      # 50 messages from sender B within 30 days
      50.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_b_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2020,7,21)
                      )
      end

      # stub out Time.now to return 8/20/21
      allow(DateTime).to receive(:now) do
        DateTime.new(2020,8,20)
      end
    end

    describe '.from_all_senders' do
      it 'returns last 100 messages from all senders for a given recipient when limit=100' do
        limit = "100"
        messages = Message.from_all_senders(@recipient_id, limit)

        expect(messages.length).to eq(100)
        expect(messages.first.sender_id).to eq(@sender_a_id)
        expect(messages.first.created_at).to eq("2020-08-15T00:00:00.000Z")
        expect(messages[50].sender_id).to eq(@sender_b_id)
        expect(messages[50].created_at).to eq("2020-07-21T00:00:00.000Z")
        expect(messages.last.sender_id).to eq(@sender_a_id)
        expect(messages.last.created_at).to eq("2020-07-01T00:00:00.000Z")
      end

      it 'returns last 30d of messages from all senders for a given recipient when limit=30d' do
        limit = "30d"
        messages = Message.from_all_senders(@recipient_id, limit)

        expect(messages.length).to eq(75)
        expect(messages.first.sender_id).to eq(@sender_a_id)
        expect(messages.first.created_at).to eq("2020-08-15T00:00:00.000Z")
        expect(messages.last.sender_id).to eq(@sender_b_id)
        expect(messages.last.created_at).to eq("2020-07-21T00:00:00.000Z")
      end
    end

    describe '.from_sender' do
      it 'returns last 100 messages from given sender for a given recipient when limit=100' do
        limit = "100"
        messages = Message.from_sender(@recipient_id, @sender_a_id, limit)

        expect(messages.length).to eq(100)
        expect(messages.first.sender_id).to eq(@sender_a_id)
        expect(messages.first.created_at).to eq("2020-08-15T00:00:00.000Z")
        expect(messages.last.sender_id).to eq(@sender_a_id)
        expect(messages.last.created_at).to eq("2020-05-01T00:00:00.000Z")
      end

      it 'returns last 30d of messages from given sender for a given recipient when limit=30d' do
        limit = "30d"
        messages = Message.from_sender(@recipient_id, @sender_a_id, limit)

        expect(messages.length).to eq(25)
        expect(messages.first.sender_id).to eq(@sender_a_id)
        expect(messages.first.created_at).to eq("2020-08-15T00:00:00.000Z")
        expect(messages.last.sender_id).to eq(@sender_a_id)
        expect(messages.last.created_at).to eq("2020-08-15T00:00:00.000Z")
      end
    end
  end
end
