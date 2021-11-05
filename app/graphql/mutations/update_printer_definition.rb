module Mutations
  class UpdatePrinterDefinition < BaseMutation
    type Types::PrinterDefinitionType

    argument :id, ID, required: true
    argument :name, String, required: true

    def resolve(id:, name:)
      pd = PrinterDefinition.find(id)
      pd.name = name
      pd.save!
      pd
    end
  end
end
