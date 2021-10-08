# frozen_string_literal: true

class PrinterChannel < ApplicationCable::Channel
  # TODO: try to find an alternative to class variables
  @@semaphores = {}
  @@errors = {}

  class << self
    def transmit_start_print(printer:, print_id:, download_url:)
      unless @@semaphores[printer].nil?
        raise RuntimeError.new('Already waiting for a print')
      end

      semaphore = Concurrent::Semaphore.new(0)
      @@semaphores[printer] = semaphore
      broadcast_to printer, self.start_print_message(print_id: print_id, download_url: download_url)

      result = semaphore.try_acquire(1, 10)

      @@semaphores.delete(printer)

      unless result
        raise RuntimeError.new('Timed out')
      end

      error = @@errors[printer]

      if error
        @@errors.delete(printer)
        raise RuntimeError.new(error)
      end
    end

    def transmit_reconnect(printer)
      broadcast_to printer, self.reconnect_message
    end
  end

  def subscribed
    device = Device.find_by_hardware_identifier(params['hardware_identifier'])

    return reject unless device

    @printer = device.printer

    return reject unless @printer

    stream_for @printer
  end

  def acknowledge_print(args)
    unless args['success']
      @@errors[@printer] = args['error_message']
    end

    @@semaphores[@printer].release
  end

  def log_message(args)
    return unless args.key?('message')

    PrinterListenerChannel.broadcast_to @printer, { action: 'log_message', message: args['message'] }
  end

  private
    def self.start_print_message(print_id:, download_url:)
      {
        action: 'start_print',
        print_id: print_id,
        download_url: download_url,
      }
    end

    def self.reconnect_message
      {
        action: 'reconnect'
      }
    end
end
