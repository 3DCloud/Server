# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :client

    attr_reader :client

    def connect
      reject unless request.headers.key?("X-Client-Id") && request.headers.key?("X-Client-Secret")

      client_id = request.headers["X-Client-Id"]
      client_secret = request.headers["X-Client-Secret"]

      reject_unauthorized_connection if client_id.blank? || client_id.length != 36 || client_secret.blank? || client_secret.length != 48

      @client = Client.find_by_id(client_id)

      if @client.nil?
        @client = Client.new(id: client_id, secret: client_secret)
        @client.save!
      end

      reject_unauthorized_connection unless @client.secret == client_secret && @client.authorized
    end
  end
end
