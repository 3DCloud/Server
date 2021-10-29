# frozen_string_literal: true

module Mutations
  class CreatePrinterMutation < BaseMutation
    argument :name, String, required: true
    argument :device_id, ID, required: true
    argument :printer_definition_id, ID, required: true

    type Types::PrinterType

    def resolve(name:, device_id:, printer_definition_id:)
      printer = Printer.new(name: name, device_id: device_id, printer_definition_id: printer_definition_id, state: 'offline')
      printer.save!

      ClientChannel.transmit_printer_configuration printer

      printer
    end
  end
end
