# frozen_string_literal: true

module Mutations
  class CreatePrinter < BaseMutation
    argument :name, String, required: true
    argument :device_id, ID, required: true
    argument :printer_definition_id, ID, required: true

    type Types::PrinterType

    def resolve(name:, device_id:, printer_definition_id:)
      authorize!(:create, Printer)

      printer = Printer.new(name: name, device_id: device_id, printer_definition_id: printer_definition_id, state: 'offline')

      ApplicationRecord.transaction do
        existing = Printer.find_by(device_id: device_id)

        if existing
          authorize!(:update, existing)

          printer.current_print_id = existing.current_print_id
          printer.state = existing.state

          existing.update!(
            device_id: nil,
            current_print_id: nil,
            state: 'offline'
          )
        end

        printer.save!
      end

      begin
        unless %w(offline disconnected).include?(printer.state)
          ClientChannel.transmit_printer_configuration printer
        end
      rescue => err
        Rails.logger.error err
      end

      printer
    end
  end
end
