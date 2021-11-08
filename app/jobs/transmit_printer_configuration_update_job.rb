# frozen_string_literal: true

class TransmitPrinterConfigurationUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Printer.includes(device: :client, printer_definition: :g_code_settings).where(printer_definition_id: args[0]).each do |printer|
      ClientChannel.transmit_printer_configuration(printer)
    rescue ApplicationCable::ApplicationCableError => err
      logger.error err
    end
  end
end
