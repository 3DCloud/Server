# frozen_string_literal: true

class ClientChannel < ApplicationCable::Channel
  class << self
    def transmit_printer_configuration(printer)
      broadcast_to printer.device.client, self.printer_configuration_message(printer)
    end
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
    ApplicationRecord.transaction do
      Printer.for_client(connection.client.id).includes(:device).each do |printer|
        state = args['printers'][printer.device.hardware_identifier]

        if state
          printer.state = state['printer_state']
        else
          printer.state = 'disconnected'
          state = { printer_state: 'disconnected' }
        end

        printer.save!
        PrinterListenerChannel.transmit_printer_state(printer, state)
      end
    end
  end

  private
    def subscribed
      stream_for connection.client
    end

    def unsubscribed
      ApplicationRecord.transaction do
        Printer.for_client(connection.client.id).each do |printer|
          printer.state = 'offline'
          printer.save!
          PrinterListenerChannel.transmit_printer_state(printer, { printer_state: 'offline' })
        end
      end
    end

    def self.printer_configuration_message(printer)
      {
        action: 'printer_configuration',
        printer: printer.as_json(include: [:device, :printer_definition])
      }
    end
end
