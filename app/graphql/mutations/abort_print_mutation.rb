module Mutations
  class AbortPrintMutation < BaseMutation
    argument :id, ID, required: true

    type Types::PrintType

    def resolve(id:)
      print = Print.includes(:printer).find(id)
      PrinterChannel.transmit_abort_print(printer: print.printer)
      print
    end
  end
end
