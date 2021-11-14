# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    @@requests = {}

    class << self
      # Subscriptions should really have a public API... oh well!
      def find_subscription(kwargs)
        ActionCable.server.connections.flat_map { |conn| conn.subscriptions.send(:subscriptions)[{ **kwargs }.to_json] }.find(&:itself)
      end
    end

    def acknowledge(args)
      id = args['message_id']

      return unless @@requests.key?(id)

      data = @@requests[id]
      data[:error_message] = args['error_message']
      data[:semaphore].release
    end

    protected
      def self.broadcast_to_with_ack(model, message, timeout = 5)
        id = SecureRandom.hex(32)
        semaphore = Concurrent::Semaphore.new(0)
        data = { semaphore: semaphore }

        @@requests[id] = data
        message[:message_id] = id

        broadcast_to model, message

        result = semaphore.try_acquire(1, timeout)

        @@requests.delete(id)

        unless result
          raise ApplicationCable::CommunicationError, 'Request timed out'
        end

        if data[:error_message].present?
          raise ApplicationCable::AcknowledgementError, data[:error_message]
        end
      end
  end
end
