# frozen_string_literal: true

module Mutations
  class CreateMaterial < BaseMutation
    type Types::MaterialType

    argument :material, Types::MaterialInput, required: true

    def resolve(material:)
      material_record = Material.new(
        name: material.name,
        brand: material.brand,
        net_filament_weight: material.net_filament_weight,
        empty_spool_weight: material.empty_spool_weight,
        filament_diameter: material.filament_diameter,
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
