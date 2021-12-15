# frozen_string_literal: true

class TransmitPrinterConfigurationUpdateJob < ApplicationJob
  queue_as :default

  def perform(printer_id: nil, printer_definition_id: nil)
    unless printer_id || printer_definition_id
      raise ApplicationJob::ArgumentError, 'Must specify one of printer_id, printer_definition_id'
    end

    query = Printer.includes(device: :client, printer_definition: :g_code_settings)

    if printer_definition_id
      query = query.where(printer_definition_id: printer_definition_id)
    end

    if printer_id
      query = query.where(id: printer_id)
    end

    query.where.not(device: nil).each do |printer|
      return if printer.id != printer_id && %w(offline disconnected).include?(printer.state)
      return unless ActionCable.server.remote_connections.where(client: printer.device.client, user: nil).present?

      tries = 0

      while true
        begin
          logger.info "Transmitting to '#{printer.name}'"
          ClientChannel.transmit_printer_configuration(printer)
          break
        rescue ApplicationCable::CommunicationError => err
          logger.error err

          tries += 1

          if tries >= 5
            raise
          end
        end
      end
    rescue => err
      logger.error err.message
      logger.error err.backtrace&.join('\n')
    end
  end
end
