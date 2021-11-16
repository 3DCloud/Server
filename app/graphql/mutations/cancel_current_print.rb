# frozen_string_literal: true

module Mutations
  class CancelCurrentPrint < BaseMutation
    argument :id, ID, required: true

    type Types::PrintType

    def resolve(id:)
      printer = Printer.includes(current_print: [ :uploaded_file ]).find(id)

      return nil unless printer.current_print

      print = printer.current_print

      authorize!(:cancel, print)

      PrinterChannel.transmit_abort_print(printer: printer)

      print
    end
  end
end
