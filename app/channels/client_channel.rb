# frozen_string_literal: true

class ClientChannel < ApplicationCable::Channel
  class << self
    def transmit_printer_configuration(printer)
      broadcast_to printer.device.client, self.printer_configuration_message(printer)
    end
  end

  def subscribed
    stream_for connection.client
  end

  def device(args)
    device = Device.find_by_hardware_identifier(args['hardware_identifier'])

    if device.nil?
      device = Device.new(hardware_identifier: args['hardware_identifier'], is_portable_hardware_identifier: args['is_portable_hardware_identifier'])
    end

    device.client = connection.client
    device.device_name = args['device_name']
    device.last_seen = DateTime.now.utc
    device.save!

    printer = Printer.includes(:device, :printer_definition).where(device: { hardware_identifier: args['hardware_identifier'] }).first

    if printer.present?
      transmit self.class.printer_configuration_message(printer)
    end
  end

  def printer_states(args)
    args['printers'].each do |state|
      printer = Printer.joins(:device).find_by!(device: { hardware_identifier: state['hardware_identifier'] })

      printer.state = state['printer_state']
      printer.save!

      PrinterListenerChannel.transmit_printer_state(printer, state)
    end
  end

  private
    def self.printer_configuration_message(printer)
      {
        action: 'printer_configuration',
        printer: printer.as_json(include: [:device, :printer_definition])
      }
    end
end
