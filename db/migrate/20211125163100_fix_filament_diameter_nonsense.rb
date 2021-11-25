# frozen_string_literal: true

class FixFilamentDiameterNonsense < ActiveRecord::Migration[6.1]
  def change
    add_column :printer_definitions, :filament_diameter, :float, null: false, default: 2.85
    remove_column :printer_extruders, :filament_diameter, :float
    remove_column :materials, :filament_diameter, :float
  end
end
