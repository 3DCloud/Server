# frozen_string_literal: true

class ReplaceDecimalWithFloat < ActiveRecord::Migration[6.1]
  def up
    change_column :materials, :filament_diameter, :float
    change_column :ulti_g_code_settings, :retraction_length, :float
    change_column :ulti_g_code_settings, :end_of_print_retraction_length, :float
    change_column :ulti_g_code_settings, :retraction_speed, :float
  end

  def down
    change_column :materials, :filament_diameter, :decimal, precision: 3, scale: 2
    change_column :ulti_g_code_settings, :retraction_length, :decimal, precision: 4, scale: 2
    change_column :ulti_g_code_settings, :end_of_print_retraction_length, :decimal, precision: 4, scale: 2
    change_column :ulti_g_code_settings, :retraction_speed, :decimal, precision: 4, scale: 1
  end
end
