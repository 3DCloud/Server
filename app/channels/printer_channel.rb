# frozen_string_literal: true

class PrinterChannel < ApplicationCable::Channel
  class << self
    def transmit_start_print(printer:, print_id:, download_url:)
      broadcast_to printer, self.start_print_message(print_id: print_id, download_url: download_url)
    end

    def transmit_reconnect(printer)
      broadcast_to printer, self.reconnect_message
    end
  end

  def subscribed
    unless params['hardware_identifier'].present?
      reject
      return
    end

    device = Device.find_by_hardware_identifier(params['hardware_identifier'])

    unless device
      reject
      return
    end

    @printer = device.printer

    unless @printer
      reject
      return
    end

    stream_for @printer
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
