# frozen_string_literal: true

class AddPerNozzleColumns < ActiveRecord::Migration[6.1]
  def up
    add_column :ulti_g_code_settings, :hotend_temperature_0_25, :integer
    add_column :ulti_g_code_settings, :retraction_length_0_25, :float
    add_column :ulti_g_code_settings, :retraction_speed_0_25, :float

    add_column :ulti_g_code_settings, :hotend_temperature_0_40, :integer
    add_column :ulti_g_code_settings, :retraction_length_0_40, :float
    add_column :ulti_g_code_settings, :retraction_speed_0_40, :float

    add_column :ulti_g_code_settings, :hotend_temperature_0_60, :integer
    add_column :ulti_g_code_settings, :retraction_length_0_60, :float
    add_column :ulti_g_code_settings, :retraction_speed_0_60, :float

    add_column :ulti_g_code_settings, :hotend_temperature_0_80, :integer
    add_column :ulti_g_code_settings, :retraction_length_0_80, :float
    add_column :ulti_g_code_settings, :retraction_speed_0_80, :float

    add_column :ulti_g_code_settings, :hotend_temperature_1_00, :integer
    add_column :ulti_g_code_settings, :retraction_length_1_00, :float
    add_column :ulti_g_code_settings, :retraction_speed_1_00, :float

    UltiGCodeSettings.in_batches.each_record do |ulti_g_code_settings|
      ulti_g_code_settings.hotend_temperature_0_25 = ulti_g_code_settings.hotend_temperature
      ulti_g_code_settings.retraction_length_0_25 = ulti_g_code_settings.retraction_length
      ulti_g_code_settings.retraction_speed_0_25 = ulti_g_code_settings.retraction_speed

      ulti_g_code_settings.hotend_temperature_0_40 = ulti_g_code_settings.hotend_temperature
      ulti_g_code_settings.retraction_length_0_40 = ulti_g_code_settings.retraction_length
      ulti_g_code_settings.retraction_speed_0_40 = ulti_g_code_settings.retraction_speed

      ulti_g_code_settings.hotend_temperature_0_60 = ulti_g_code_settings.hotend_temperature
      ulti_g_code_settings.retraction_length_0_60 = ulti_g_code_settings.retraction_length
      ulti_g_code_settings.retraction_speed_0_60 = ulti_g_code_settings.retraction_speed

      ulti_g_code_settings.hotend_temperature_0_80 = ulti_g_code_settings.hotend_temperature
      ulti_g_code_settings.retraction_length_0_80 = ulti_g_code_settings.retraction_length
      ulti_g_code_settings.retraction_speed_0_80 = ulti_g_code_settings.retraction_speed

      ulti_g_code_settings.hotend_temperature_1_00 = ulti_g_code_settings.hotend_temperature
      ulti_g_code_settings.retraction_length_1_00 = ulti_g_code_settings.retraction_length
      ulti_g_code_settings.retraction_speed_1_00 = ulti_g_code_settings.retraction_speed

      ulti_g_code_settings.save!
    end

    change_column_null :ulti_g_code_settings, :hotend_temperature_0_25, false
    change_column_null :ulti_g_code_settings, :retraction_length_0_25, false
    change_column_null :ulti_g_code_settings, :retraction_speed_0_25, false

    change_column_null :ulti_g_code_settings, :hotend_temperature_0_40, false
    change_column_null :ulti_g_code_settings, :retraction_length_0_40, false
    change_column_null :ulti_g_code_settings, :retraction_speed_0_40, false

    change_column_null :ulti_g_code_settings, :hotend_temperature_0_60, false
    change_column_null :ulti_g_code_settings, :retraction_length_0_60, false
    change_column_null :ulti_g_code_settings, :retraction_speed_0_60, false

    change_column_null :ulti_g_code_settings, :hotend_temperature_0_80, false
    change_column_null :ulti_g_code_settings, :retraction_length_0_80, false
    change_column_null :ulti_g_code_settings, :retraction_speed_0_80, false

    change_column_null :ulti_g_code_settings, :hotend_temperature_1_00, false
    change_column_null :ulti_g_code_settings, :retraction_length_1_00, false
    change_column_null :ulti_g_code_settings, :retraction_speed_1_00, false

    remove_column :ulti_g_code_settings, :hotend_temperature
    remove_column :ulti_g_code_settings, :retraction_length
    remove_column :ulti_g_code_settings, :retraction_speed
  end

  def down
    add_column :ulti_g_code_settings, :hotend_temperature, :integer
    add_column :ulti_g_code_settings, :retraction_length, :float
    add_column :ulti_g_code_settings, :retraction_speed, :float

    UltiGCodeSettings.in_batches.each_record do |ulti_g_code_settings|
      ulti_g_code_settings.hotend_temperature = ulti_g_code_settings.hotend_temperature_0_40
      ulti_g_code_settings.retraction_length = ulti_g_code_settings.retraction_length_0_40
      ulti_g_code_settings.retraction_speed = ulti_g_code_settings.retraction_speed_0_40
      ulti_g_code_settings.save!
    end

    change_column_null :ulti_g_code_settings, :hotend_temperature, false
    change_column_null :ulti_g_code_settings, :retraction_length, false
    change_column_null :ulti_g_code_settings, :retraction_speed, false

    remove_column :ulti_g_code_settings, :hotend_temperature_0_25
    remove_column :ulti_g_code_settings, :retraction_length_0_25
    remove_column :ulti_g_code_settings, :retraction_speed_0_25

    remove_column :ulti_g_code_settings, :hotend_temperature_0_40
    remove_column :ulti_g_code_settings, :retraction_length_0_40
    remove_column :ulti_g_code_settings, :retraction_speed_0_40

    remove_column :ulti_g_code_settings, :hotend_temperature_0_60
    remove_column :ulti_g_code_settings, :retraction_length_0_60
    remove_column :ulti_g_code_settings, :retraction_speed_0_60

    remove_column :ulti_g_code_settings, :hotend_temperature_0_80
    remove_column :ulti_g_code_settings, :retraction_length_0_80
    remove_column :ulti_g_code_settings, :retraction_speed_0_80

    remove_column :ulti_g_code_settings, :hotend_temperature_1_00
    remove_column :ulti_g_code_settings, :retraction_length_1_00
    remove_column :ulti_g_code_settings, :retraction_speed_1_00
  end
end
