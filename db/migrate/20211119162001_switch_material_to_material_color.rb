class SwitchMaterialToMaterialColor < ActiveRecord::Migration[6.1]
  def change
    remove_reference :printer_extruders, :material
    add_reference :printer_extruders, :material_color
    change_column_null :printer_extruders, :ulti_g_code_nozzle_size, true
  end
end
