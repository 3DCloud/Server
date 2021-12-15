# frozen_string_literal: true

class PrinterChannel < ApplicationCable::Channel
  class << self
    def transmit_reconnect(printer:)
      self.ensure_online(printer)
      self.broadcast_to_with_ack printer.device, self.reconnect_message, 15
    end

    def transmit_start_print(printer:, print_id:, download_url:)
      self.ensure_online(printer)
      self.broadcast_to_with_ack printer.device, self.start_print_message(print_id: print_id, download_url: download_url)
    end

    def transmit_abort_print(printer:)
      self.ensure_online(printer)
      self.broadcast_to_with_ack printer.device, self.abort_print_message
    end
  end

  def subscribed
    return reject unless connection.client

    @device = Device.includes(:printer).find_by(client: connection.client, path: params['device_path'])

    return reject unless @device&.printer

    stream_for @device
  end

  def print_event(args)
    @device.reload

    printer = @device.printer
    print = printer.current_print

    return unless print

    ApplicationRecord.transaction do
      status = args['event_type']

      if status == Print::PrintStatus::RUNNING
        print.started_at = DateTime.now.utc
      end

      if Print::PrintStatus::COMPLETED_STATUSES.include?(status)
        printer.current_print = nil

        unless Print::PrintStatus::COMPLETED_STATUSES.include?(print.status)
          print.completed_at = DateTime.now.utc

          case status
          when Print::PrintStatus::SUCCESS
            UserMailer.with(print: print).print_completed_email.deliver_later
          when Print::PrintStatus::CANCELED
            unless print.user == print.canceled_by
              UserMailer.with(print: print).print_canceled_email.deliver_later
            end
          when Print::PrintStatus::ERRORED
            UserMailer.with(print: print).print_failed_email.deliver_later
          end
        end
      end

      print.status = status
      print.save!
      printer.save!
    end
  end

  def log_message(args)
    return unless args.key?('message')

    PrinterListenerChannel.broadcast_to @device.printer, { action: 'log_message', message: args['message'] }
  end

  private
    def self.ensure_online(printer)
      raise ApplicationCable::CommunicationError, 'Printer is not connected' if printer.state == 'offline'
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
