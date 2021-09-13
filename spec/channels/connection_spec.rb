# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  describe 'connect' do
    it 'accepts connections from known clients' do
      secret = SecureRandom.urlsafe_base64(36)
      client = create(:client, secret: secret)

      expect {
        connect headers: { 'X-Client-Id' => client.id, 'X-Client-Secret' => secret }
      }.to_not raise_error

      expect(connection.client).to eq(client)
    end

    it 'registers unknown clients' do
      id = SecureRandom.uuid
      secret = SecureRandom.urlsafe_base64(36)

      freeze_time do
        expect {
          connect headers: { 'X-Client-Id' => id, 'X-Client-Secret' => secret }
        }.to have_rejected_connection
          .and change { Client.count }.by(1)

        client = Client.last
        expect(client.id).to eq(id)
        expect(client.secret).to eq(secret)
        expect(client.authorized).to eq(false)
      end
    end

    it 'rejects connections with malformed X-Client-Id' do
      expect {
        connect headers: { 'X-Client-Id' => SecureRandom.uuid[1..], 'X-Client-Secret' => SecureRandom.urlsafe_base64(36) }
      }.to have_rejected_connection
    end

    it 'rejects connections with malformed X-Client-Secret' do
      expect {
        connect headers: { 'X-Client-Id' => SecureRandom.uuid, 'X-Client-Secret' => SecureRandom.urlsafe_base64(36)[1..] }
      }.to have_rejected_connection
    end

    it 'rejects connections with missing X-Client-Id' do
      expect {
        connect headers: { 'X-Client-Secret' => SecureRandom.urlsafe_base64(36) }
      }.to have_rejected_connection
    end

    it 'rejects connections with missing X-Client-Secret' do
      expect {
        connect headers: { 'X-Client-Id' => SecureRandom.uuid }
      }.to have_rejected_connection
    end
  end
end
