# frozen_string_literal: true

module Mutations
  class ReassignPrinter < BaseMutation
    type Types::PrinterType

    argument :printer_id, ID, required: true
    argument :device_id, ID, required: true

    def resolve(printer_id:, device_id:)
      printer = Printer.find(printer_id)
      other_printer = Printer.find_by(device_id: device_id)

      authorize!(:update, printer)
      authorize!(:update, other_printer)

      unless printer.current_print_id.nil? && (other_printer.nil? || other_printer.current_print_id.nil?)
        raise RuntimeError, 'A print is currently running. Please wait until it has completed or cancel it before reassigning.'
      end

      ApplicationRecord.transaction do
        if other_printer.present?
          other_printer.device_id = printer.device_id
          other_printer.save!
          other_printer.state = 'offline'
        end

        printer.device_id = device_id
        printer.save!
      end
      printer
    end
  end
end
