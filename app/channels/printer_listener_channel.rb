# frozen_string_literal: true

class PrinterListenerChannel < ApplicationCable::Channel
  class << self
    def transmit_printer_state(printer, state)
      message = self.printer_state_message(state)
      broadcast_to printer, message
      broadcast_to :all, { **message, id: printer.id.to_s }
    end
  end

  def subscribed
    unless params['id'].present?
      stream_for :all
      return
    end

    @printer = Printer.find_by(id: params['id'])

    if @printer.nil?
      reject
      return
    end

    stream_for @printer
  end

  def send_command(args)
    return unless args.key?('command')

    PrinterChannel.broadcast_to @printer, { action: 'send_command', command: args['command'] }
  end

  private
    def self.printer_state_message(state)
      {
        action: 'state',
        state: state,
      }
    end
end
