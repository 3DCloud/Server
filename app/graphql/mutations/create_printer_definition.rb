# frozen_string_literal: true

module Mutations
  class CreatePrinterDefinition < BaseMutation
    type Types::PrinterDefinitionType

    argument :printer_definition, Types::PrinterDefinitionInput, required: true

    def resolve(printer_definition:)
      pd = PrinterDefinition.new(
        name: printer_definition.name,
        extruder_count: printer_definition.extruder_count,
        driver: 'marlin'
      )

      pd.g_code_settings = GCodeSettings.new(
        start_g_code: printer_definition.g_code_settings.start_g_code,
        end_g_code: printer_definition.g_code_settings.end_g_code,
        cancel_g_code: printer_definition.g_code_settings.cancel_g_code,
      )

      printer_definition.ulti_g_code_settings.each do |input|
        ugs = UltiGCodeSettings.new(
          printer_definition: pd,
          material_id: input.material_id,
          hotend_temperature: input.hotend_temperature,
          build_plate_temperature: input.build_plate_temperature,
          retraction_length: input.retraction_length,
          end_of_print_retraction_length: input.end_of_print_retraction_length,
          retraction_speed: input.retraction_speed,
          fan_speed: input.fan_speed,
          flow_rate: input.flow_rate,
        )
        ugs.save!
      end

      pd.g_code_settings.save!
      pd.save!
      pd
    end
  end
end
