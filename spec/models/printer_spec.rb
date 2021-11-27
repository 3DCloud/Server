# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Printer, type: :model do
  describe 'ulti_g_code_settings' do
    it 'returns the expected data when settings are available' do
      printer = create(:printer, printer_definition: create(:printer_definition, extruder_count: 2))
      material1 = create(:material)
      material2 = create(:material)
      material_color1 = create(:material_color, material: material1)
      material_color2 = create(:material_color, material: material2)
      ulti_g_code_settings1 = create(:ulti_g_code_settings, material: material1, printer_definition: printer.printer_definition)
      ulti_g_code_settings2 = create(:ulti_g_code_settings, material: material2, printer_definition: printer.printer_definition)

      printer.reload
      printer.printer_extruders[0].update!(material_color: material_color1, ulti_g_code_nozzle_size: 'size_0_60')
      printer.printer_extruders[1].update!(material_color: material_color2, ulti_g_code_nozzle_size: 'size_1_00')


      expect(printer.ulti_g_code_settings).to eq([
        {
          material_name: material1.name,
          build_plate_temperature: ulti_g_code_settings1.build_plate_temperature,
          end_of_print_retraction_length: ulti_g_code_settings1.end_of_print_retraction_length,
          hotend_temperature: ulti_g_code_settings1.hotend_temperature_0_60,
          retraction_length: ulti_g_code_settings1.retraction_length_0_60,
          retraction_speed: ulti_g_code_settings1.retraction_speed_0_60,
          fan_speed: ulti_g_code_settings1.fan_speed,
          flow_rate: ulti_g_code_settings1.flow_rate,
          filament_diameter: printer.printer_definition.filament_diameter,
          created_at: ulti_g_code_settings1.created_at,
          updated_at: ulti_g_code_settings1.updated_at,
        },
        {
          material_name: material2.name,
          build_plate_temperature: ulti_g_code_settings2.build_plate_temperature,
          end_of_print_retraction_length: ulti_g_code_settings2.end_of_print_retraction_length,
          hotend_temperature: ulti_g_code_settings2.hotend_temperature_1_00,
          retraction_length: ulti_g_code_settings2.retraction_length_1_00,
          retraction_speed: ulti_g_code_settings2.retraction_speed_1_00,
          fan_speed: ulti_g_code_settings2.fan_speed,
          flow_rate: ulti_g_code_settings2.flow_rate,
          filament_diameter: printer.printer_definition.filament_diameter,
          created_at: ulti_g_code_settings2.created_at,
          updated_at: ulti_g_code_settings2.updated_at,
        }
      ])
    end
  end
end
