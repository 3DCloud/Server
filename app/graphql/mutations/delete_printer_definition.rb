module Mutations
  class DeletePrinterDefinition < BaseMutation
    type Types::PrinterDefinitionType

    argument :id, ID, required: true

    def resolve(id:)
      PrinterDefinition.find(id).destroy!
    end
  end
end
