# frozen_string_literal: true

module Types
  class MaterialInput < Types::BaseInputObject
    argument :name, String, required: true
    argument :brand, String, required: true
    argument :net_filament_weight, Int, required: true
    argument :empty_spool_weight, Int, required: true
    argument :filament_diameter, Float, required: true
    argument :material_colors, [Types::MaterialColorInput], required: true
  end
end
