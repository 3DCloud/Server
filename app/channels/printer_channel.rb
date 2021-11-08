# frozen_string_literal: true

class PrinterChannel < ApplicationCable::Channel
  class << self
    def transmit_reconnect(printer:)
      self.ensure_online(printer)
      self.broadcast_to_with_ack printer, self.reconnect_message, 30
    end

    def transmit_start_print(printer:, print_id:, download_url:)
      self.ensure_online(printer)
      self.broadcast_to_with_ack printer, self.start_print_message(print_id: print_id, download_url: download_url)
    end

    def transmit_abort_print(printer:)
      self.ensure_online(printer)
      self.broadcast_to_with_ack printer, self.abort_print_message
    end
  end

  def subscribed
    device = Device.includes(:printer).find_by(client: connection.client, hardware_identifier: params['hardware_identifier'])

    return reject unless device

    @printer = device.printer

    return reject unless @printer

    stream_for @printer
  end

  def print_event(args)
    @printer.reload

    print = @printer.current_print

    return unless print

    state = args['event_type']

    if state == 'running'
      print.started_at = DateTime.now.utc
    end

    if %w(success canceled errored).include?(state)
      @printer.current_print = nil
      @printer.save!

      print.completed_at = DateTime.now.utc
    end

    print.status = state
    print.save!
  end

  def log_message(args)
    return unless args.key?('message')

    PrinterListenerChannel.broadcast_to @printer, { action: 'log_message', message: args['message'] }
  end

  private
    def self.ensure_online(printer)
      raise ApplicationCable::CommunicationError, 'Printer is not connected' unless find_subscription({
        'hardware_identifier' => printer.device.hardware_identifier,
        'channel' => 'PrinterChannel',
      })
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
