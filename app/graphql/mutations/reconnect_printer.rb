# frozen_string_literal: true

module Mutations
  class ReconnectPrinter < BaseMutation
    argument :id, ID, required: true

    type Types::PrinterType

    def resolve(id:)
      printer = Printer.find(id)
      PrinterChannel.transmit_reconnect(printer: printer)
      printer
    end
  end
end