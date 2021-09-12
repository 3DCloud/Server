# frozen_string_literal: true

class PrinterListenerChannel < ApplicationCable::Channel
  def subscribed
    unless params['id'].present?
      reject
      return
    end

    @printer = Printer.find_by_id(params['id'])

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
end
