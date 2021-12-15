# frozen_string_literal: true

class ClientChannel < ApplicationCable::Channel
  class << self
    def transmit_printer_configuration(printer)
      broadcast_to_with_ack printer.device.client, self.printer_configuration_message(printer), 1
    end
  end

  def device(args)
    device = Device.includes(printer: :printer_definition)
                   .find_by('(client_id = ? AND path = ?) OR serial_number = ?', connection.client.id, args['path'], args['serial_number'])

    if device.nil?
      device = Device.new(client: connection.client, path: args['path'], serial_number: args['serial_number'])
    end

    device.update!(
      name: args['name'],
      last_seen: DateTime.now.utc
    )

    if device.printer.present?
      transmit self.class.printer_configuration_message(device.printer)
    end
  end

  def printer_states(args)
    ApplicationRecord.transaction do
      Printer.for_client(connection.client.id).includes(:device, :current_print).each do |printer|
        state = args['printers'][printer.device.path]

        if state
          printer.state = state['printer_state']
          printer.progress = state['progress']
        else
          printer.state = 'disconnected'
          printer.progress = nil
          state = { printer_state: 'disconnected' }
        end

        PrinterListenerChannel.transmit_printer_state(printer, state)
      end
    end
  end

  private
    def subscribed
      return reject unless connection.client
      stream_for connection.client
    end

    def unsubscribed
      ApplicationRecord.transaction do
        Printer.for_client(connection.client.id).each do |printer|
          printer.state = 'offline'
          PrinterListenerChannel.transmit_printer_state(printer, { printer_state: 'offline' })
        end
      end
    end

    def self.printer_configuration_message(printer)
      {
        action: 'printer_configuration',
        printer: printer.as_json(include: { device: {}, printer_definition: { include: :g_code_settings } }, methods: [ :ulti_g_code_settings ])
      }
    end
end
