# frozen_string_literal: true

module Mutations
  class CancelCurrentPrint < BaseMutation
    argument :id, ID, required: true

    type Types::PrinterType

    def resolve(id:)
      printer = Printer.find(id)

      return printer unless printer.current_print

      PrinterChannel.transmit_abort_print(printer: printer)

      printer
    end
  end
end
