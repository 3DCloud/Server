# frozen_string_literal: true

module Mutations
  class DeletePrinterDefinition < BaseMutation
    type Types::PrinterDefinitionType

    argument :id, ID, required: true

    def resolve(id:)
      pd = PrinterDefinition.find(id)
      pd.g_code_settings.destroy!
      pd.destroy!
    end
  end
end
