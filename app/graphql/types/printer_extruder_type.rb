module Types
  class PrinterExtruderType < Types::BaseObject
    field :id, ID, null: false
    field :printer, PrinterType, null: false
    field :printer_id, ID, null: false
    field :material_color, MaterialColorType, null: true
    field :material_color_id, ID, null: true
    field :extruder_index, Int, null: false
    field :ulti_g_code_nozzle_size, String, null: true
    field :filament_diameter, Float, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
