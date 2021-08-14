# frozen_string_literal: true

module Mutations
  class DeletePrinterMutation < BaseMutation
    field :delete_count, Int, null: false

    argument :id, ID, required: true

    def resolve(id:)
      { delete_count: Printer.delete(id) }
    end
  end
end
