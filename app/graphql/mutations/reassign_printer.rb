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

      if other_printer
        authorize!(:update, other_printer)
      end

      ApplicationRecord.transaction do
        printer.device_id = device_id

        if other_printer
          printer.assign_attributes(
            current_print_id: other_printer.current_print_id,
            state: other_printer.state
          )

          other_printer.update!(
            device_id: nil,
            current_print_id: nil,
            state: 'offline'
          )
        end

        printer.save!
      end

      TransmitPrinterConfigurationUpdateJob.perform_later(printer_id: printer.id)

      printer
    end
  end
end
