# frozen_string_literal: true

module Mutations
  class DeleteMaterial < BaseMutation
    type Types::MaterialType

    argument :id, ID, required: true

    def resolve(id:)
      material = Material.find(id)
      authorize!(:delete, material)
      material.destroy!
    end
  end
end
