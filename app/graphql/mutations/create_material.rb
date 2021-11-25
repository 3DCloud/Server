# frozen_string_literal: true

module Mutations
  class CreateMaterial < BaseMutation
    type Types::MaterialType

    argument :material, Types::MaterialInput, required: true

    def resolve(material:)
      authorize!(:create, Material)
      authorize!(:create, MaterialColor)

      # TODO: check if this can/should be moved to an ActiveRecord validation
      if material.material_colors.length == 0
        raise ActiveRecord::ActiveRecordError, 'Must have at least one material color'
      end

      material_record = Material.new(
        name: material.name,
        brand: material.brand,
        net_filament_weight: material.net_filament_weight,
        empty_spool_weight: material.empty_spool_weight,
        material_colors: material.material_colors.map do |material_color|
            MaterialColor.new(
              name: material_color.name,
              color: material_color.color
            )
          end
      )
      material_record.save!
      material_record
    end
  end
end
