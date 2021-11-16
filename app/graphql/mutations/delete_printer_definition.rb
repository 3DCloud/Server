# frozen_string_literal: true

module Mutations
  class DeletePrinterDefinition < BaseMutation
    type Types::PrinterDefinitionType

    argument :id, ID, required: true

    def resolve(id:)
      printer_definition = PrinterDefinition.find(id)
      authorize!(:delete, printer_definition)
      printer_definition.destroy!
    end
  end
end
