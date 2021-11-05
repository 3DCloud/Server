module Mutations
  class CreatePrinterDefinition < BaseMutation
    type Types::PrinterDefinitionType

    argument :name, String, required: true

    def resolve(name:)
      pd = PrinterDefinition.new(name: name, driver: 'marlin')
      pd.save!
      pd
    end
  end
end
