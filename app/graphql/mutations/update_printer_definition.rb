# frozen_string_literal: true

module Mutations
  class UpdatePrinterDefinition < BaseMutation
    type Types::PrinterDefinitionType

    argument :id, ID, required: true
    argument :printer_definition, Types::PrinterDefinitionInput, required: true

    def resolve(id:, printer_definition:)
      ApplicationRecord.transaction do
        pd = PrinterDefinition.includes(:g_code_settings, :ulti_g_code_settings).find(id)
        pd.name = printer_definition.name
        pd.extruder_count = printer_definition.extruder_count

        unless pd.g_code_settings
          pd.g_code_settings = GCodeSettings.new(
            printer_definition: pd
          )
        end

        pd.g_code_settings.start_g_code = printer_definition.g_code_settings.start_g_code
        pd.g_code_settings.end_g_code = printer_definition.g_code_settings.end_g_code
        pd.g_code_settings.cancel_g_code = printer_definition.g_code_settings.cancel_g_code
        pd.g_code_settings.save!

        pd.ulti_g_code_settings.where.not(id: printer_definition.ulti_g_code_settings.map(&:id)).destroy_all

        printer_definition.ulti_g_code_settings.each do |ulti_g_code_settings|
          ugs = if ulti_g_code_settings.id
            pd.ulti_g_code_settings.find_by!(
              id: ulti_g_code_settings.id,
            )
          else
            UltiGCodeSettings.new(
              printer_definition: pd
            )
          end

          ugs.material_id = ulti_g_code_settings.material_id
          ugs.hotend_temperature = ulti_g_code_settings.hotend_temperature
          ugs.build_plate_temperature = ulti_g_code_settings.build_plate_temperature
          ugs.retraction_length = ulti_g_code_settings.retraction_length
          ugs.end_of_print_retraction_length = ulti_g_code_settings.end_of_print_retraction_length
          ugs.retraction_speed = ulti_g_code_settings.retraction_speed
          ugs.fan_speed = ulti_g_code_settings.fan_speed
          ugs.flow_rate = ulti_g_code_settings.flow_rate
          ugs.save!
        end

        pd.save!
        pd
      end
    end
  end
end
