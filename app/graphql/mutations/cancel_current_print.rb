# frozen_string_literal: true

module Mutations
  class CancelCurrentPrint < BaseMutation
    argument :id, ID, required: true
    argument :cancellation_reason_id, ID, required: false
    argument :cancellation_reason_details, String, required: false

    type Types::PrintType

    def resolve(id:, cancellation_reason_id: nil, cancellation_reason_details: nil)
      printer = Printer.includes(:current_print).find(id)

      return nil unless printer.current_print

      print = printer.current_print

      if Print::PrintStatus::COMPLETED_STATUSES.include?(print.status)
        printer.current_print = nil
        printer.save!
        return
      end

      authorize!(:cancel, print)

      print.status = Print::PrintStatus::CANCELING
      print.canceled_by = context[:current_user]
      print.cancellation_reason_id = cancellation_reason_id
      print.cancellation_reason_details = cancellation_reason_details
      print.save!

      PrinterChannel.transmit_abort_print(printer: printer)

      print
    end
  end
end
