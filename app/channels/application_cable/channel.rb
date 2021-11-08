# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    class << self
      # Subscriptions should really have a public API... oh well!
      def find_subscription(**kwargs)
        ActionCable.server.connections.flat_map { |conn| conn.subscriptions.send(:subscriptions)[{ **kwargs }.to_json] }.find(&:itself)
      end
    end
  end
end
