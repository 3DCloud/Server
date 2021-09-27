# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include JwtHelper

    identified_by :client
    identified_by :user

    attr_reader :client

    def connect
      if request.headers['X-Client-Id'] && request.headers['X-Client-Secret']
        connect_client(client_id: request.headers['X-Client-Id'], client_secret: request.headers['X-Client-Secret'])
      elsif request.params['ticket']
        connect_frontend(ticket_str: request.params['ticket'])
      else
        reject_unauthorized_connection
      end
    rescue Exception => err
      logger.error err
      reject_unauthorized_connection
    end

    private
      def connect_client(client_id:, client_secret:)
        if client_id.blank? || client_id.length != 36 || client_secret.blank? || client_secret.length != 48
          reject_unauthorized_connection
        end

        @client = Client.find_by_id(client_id)

        if @client.nil?
          @client = Client.new(id: client_id, secret: client_secret)
          @client.save!
        end

        reject_unauthorized_connection unless @client.secret == client_secret && @client.authorized
      end

      def connect_frontend(ticket_str:)
        ticket = WebSocketTicket.find_by!(ticket: ticket_str, expires_at: DateTime.now.utc..)
        @user = ticket.user
        ticket.destroy!
      end
  end
end
