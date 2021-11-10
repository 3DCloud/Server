# frozen_string_literal: true

class AddVariousUniqueIndices < ActiveRecord::Migration[6.1]
  def change
    add_index :printers, :name, unique: true
    add_index :materials, [:name, :brand, :filament_diameter], unique: true
    add_index :material_colors, [ :material_id, :name ], unique: true
    add_index :ulti_g_code_settings, [ :printer_definition_id, :material_id ], unique: true, name: :index_on_printer_definition_id_and_material_id
  end
end
