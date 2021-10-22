# frozen_string_literal: true

class PrinterChannel < ApplicationCable::Channel
  @@requests = {}

  class << self
    def transmit_reconnect(printer:)
      self.broadcast_to_with_ack printer, self.reconnect_message, 30
    end

    def transmit_start_print(printer:, print_id:, download_url:)
      self.broadcast_to_with_ack printer, self.start_print_message(print_id: print_id, download_url: download_url)
    end

    def transmit_abort_print(printer:)
      self.broadcast_to_with_ack printer, self.abort_print_message
    end
  end

  def subscribed
    device = Device.find_by_hardware_identifier(params['hardware_identifier'])

    return reject unless device

    @printer = device.printer

    return reject unless @printer

    stream_for @printer
  end

  def unsubscribed
    @@requests.values.each do |data|
      data[:semaphore].release
    end
  end

  def acknowledge(args)
    id = args['message_id']

    unless @@requests.key?(id)
      return
    end

    data = @@requests[id]
    data[:error_message] = args['error_message']
    data[:semaphore].release
  end

  def print_event(args)
    puts args
  end

  def log_message(args)
    return unless args.key?('message')

    PrinterListenerChannel.broadcast_to @printer, { action: 'log_message', message: args['message'] }
  end

  private
    def self.broadcast_to_with_ack(model, message, timeout = 15)
      id = SecureRandom.hex(32)
      semaphore = Concurrent::Semaphore.new(0)
      data = { semaphore: semaphore }

      @@requests[id] = data
      message[:message_id] = id

      unless broadcast_to model, message
        raise RuntimeError.new('Failed to send request')
      end

      result = semaphore.try_acquire(1, timeout)

      @@requests.delete(id)

      unless result
        raise RuntimeError.new('Timed out')
      end

      if data[:error_message].present?
        raise RuntimeError.new(data[:error_message])
      end
    end

    def self.reconnect_message
      {
        action: 'reconnect',
      }
    end

    def self.start_print_message(print_id:, download_url:)
      {
        action: 'start_print',
        print_id: print_id,
        download_url: download_url,
      }
    end

    def self.abort_print_message
      {
        action: 'abort_print',
      }
    end
end
