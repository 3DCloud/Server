# frozen_string_literal: true

module Mutations
  class UpdateMaterial < BaseMutation
    type Types::MaterialType

    argument :id, ID, required: true
    argument :material, Types::MaterialInput, required: true

    def resolve(id:, material:)
      ApplicationRecord.transaction do
        material_record = Material.includes(:material_colors).find(id)

        material_record.update(
          name: material.name,
          brand: material.brand,
          net_filament_weight: material.net_filament_weight,
          empty_spool_weight: material.empty_spool_weight,
          filament_diameter: material.filament_diameter,
        )

        material.material_colors.each do |material_color|
          if material_color.id
            color_record = material_record.material_colors.find(material_color.id)
          else
            color_record = MaterialColor.new(material: material_record)
          end

          color_record.update!(name: material_color.name, color: material_color.color)
          color_record.save!
        end

        material_record.save!
        material_record
      end
    end
  end
end
