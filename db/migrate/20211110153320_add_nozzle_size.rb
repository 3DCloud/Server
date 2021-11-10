# frozen_string_literal: true

class AddNozzleSize < ActiveRecord::Migration[6.1]
  def change
    rename_table :printer_materials, :printer_extruders

    add_column :printer_extruders, :ulti_g_code_nozzle_size, :string, default: 'size_0_40', null: false
    add_column :printer_extruders, :filament_diameter, :float, default: 2.85, null: false

    change_column_default :printer_extruders, :ulti_g_code_nozzle_size, to: nil, from: 'size_0_40'
    change_column_default :printer_extruders, :filament_diameter, to: nil, from: 2.85
  end
end
