# frozen_string_literal: true

module Mutations
  class DeletePrinter < BaseMutation
    type Types::PrinterType

    argument :id, ID, required: true

    def resolve(id:)
      printer = Printer.find(id)
      authorize!(:delete, printer)
      printer.destroy!
    end
  end
end
