# frozen_string_literal: true

module Mutations
  class DeleteMaterial < BaseMutation
    type Types::MaterialType

    argument :id, ID, required: true

    def resolve(id:)
      Material.destroy(id)
    end
  end
end
