# frozen_string_literal: true

class CreateGCodeSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :g_code_settings do |t|
      t.references :printer_definition, foreign_key: true, null: false
      t.text :start_g_code
      t.text :end_g_code
      t.text :cancel_g_code

      t.timestamps
    end

    create_table :materials do |t|
      t.string :name, null: false
      t.string :brand, null: false
      t.decimal :filament_diameter, precision: 3, scale: 2, null: false
      t.decimal :net_filament_weight, precision: 6, scale: 0, null: false
      t.decimal :empty_spool_weight, precision: 6, scale: 2, null: false

      t.timestamps
    end

    create_table :material_colors do |t|
      t.references :material, foreign_key: true, null: false
      t.string :name, null: false
      t.string :color, limit: 6

      t.timestamps
    end

    create_table :ulti_g_code_settings do |t|
      t.references :printer_definition, foreign_key: true, null: false
      t.references :material, foreign_key: true, null: false
      t.integer :hotend_temperature, null: false
      t.integer :build_plate_temperature, null: false
      t.decimal :retraction_length, precision: 4, scale: 2, null: false
      t.decimal :end_of_print_retraction_length, precision: 4, scale: 2, null: false
      t.decimal :retraction_speed, precision: 4, scale: 1, null: false
      t.integer :fan_speed, null: false
      t.integer :flow_rate, null: false

      t.timestamps
    end

    create_table :printer_materials do |t|
      t.references :printer, foreign_key: true, null: false
      t.references :material, foreign_key: true, null: false
      t.integer :extruder_index, foreign_key: true, null: false

      t.timestamps
    end

    add_column :printer_definitions, :extruder_count, :integer, null: false, default: 1

    remove_column :printer_definitions, :start_gcode, :text
    remove_column :printer_definitions, :end_gcode, :text
    remove_column :printer_definitions, :pause_gcode, :text
    remove_column :printer_definitions, :resume_gcode, :text
  end
end
