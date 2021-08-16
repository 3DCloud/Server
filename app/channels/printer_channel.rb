# frozen_string_literal: true

class PrinterChannel < ApplicationCable::Channel
  class << self
    def transmit_reconnect(printer)
      broadcast_to printer, self.reconnect_message
    end

    def reconnect_message
      {
        action: "reconnect"
      }
    end
  end

  def subscribed
    unless params["hardware_identifier"].present?
      reject
      return
    end

    device = Device.find_by_hardware_identifier(params["hardware_identifier"])

    if device.nil?
      reject
      return
    end

    @printer = device.printer

    if @printer.nil?
      reject
      return
    end

    stream_for @printer
  end

  def state(args)
    return unless args.key?("printer_state")

    PrinterListenerChannel.broadcast_to @printer, { action: "state", printer_state: args["printer_state"] }
  end

  def log_message(args)
    return unless args.key?("message")

    PrinterListenerChannel.broadcast_to @printer, { action: "log_message", message: args["message"] }
  end
end
