# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :client

    attr_reader :client

    def connect
      if request.headers.key?("X-Client-Id") && request.headers.key?("X-Client-Secret")
        connect_client
      else
        connect_frontend
      end
    rescue StandardError => err
      logger.error err
      reject_unauthorized_connection
    end

    private
      def connect_client
        client_id = request.headers["X-Client-Id"]
        client_secret = request.headers["X-Client-Secret"]

        if client_id.blank? || client_id.length != 36 || client_secret.blank? || client_secret.length != 48
          reject_unauthorized_connection
          return
        end

        @client = Client.find_by_id(client_id)

        if @client.nil?
          @client = Client.new(id: client_id, secret: client_secret)
          @client.save!
        end

        reject_unauthorized_connection unless @client.secret == client_secret && @client.authorized
      end

      def connect_frontend
        # TODO implement
      end
  end
end
