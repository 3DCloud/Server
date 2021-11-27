# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def acknowledge(args)
      id = args['message_id']
      redis = self.class.redis_instance
      key = self.class.semaphore_name(id)

      begin
        redis.rpush(key, args)
        redis.expire(key, 10)
      ensure
        redis.disconnect!
      end
    end

    protected
      def self.broadcast_to_with_ack(model, message, timeout = 5)
        redis = redis_instance
        id = SecureRandom.hex(32)
        key = semaphore_name(id)

        message[:message_id] = id

        broadcast_to model, message

        begin
          list, data = redis.blpop(key, timeout: timeout)
        ensure
          redis.del(key)
          redis.disconnect!
        end

        if list.nil? || data.nil?
          raise ApplicationCable::CommunicationError, 'Request timed out'
        end

        if data['error_message'].present?
          raise ApplicationCable::AcknowledgementError, data['error_message']
        end
      end

    private
      def self.semaphore_name(id)
        "cable_acknowledgement:#{id}"
      end

      def self.redis_instance
        Redis.new(**Rails.application.config.x.redis)
      end
  end
end
