# frozen_string_literal: true

module Mutations
  class ReconnectPrinterMutation < BaseMutation
    argument :id, ID, required: true

    type Types::PrinterType

    def resolve(id:)
      printer = Printer.find(id)
      PrinterChannel.transmit_reconnect(printer)
      printer
    end
  end
end
