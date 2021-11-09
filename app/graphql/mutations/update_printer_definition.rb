# frozen_string_literal: true

module Mutations
  class UpdatePrinterDefinition < BaseMutation
    type Types::PrinterDefinitionType

    argument :id, ID, required: true
    argument :printer_definition, Types::PrinterDefinitionInput, required: true

    def resolve(id:, printer_definition:)
      ApplicationRecord.transaction do
        printer_definition_record = PrinterDefinition.includes(:g_code_settings, :ulti_g_code_settings).find(id)
        printer_definition_record.name = printer_definition.name
        printer_definition_record.extruder_count = printer_definition.extruder_count

        unless printer_definition_record.g_code_settings
          printer_definition_record.g_code_settings = GCodeSettings.new(
            printer_definition: printer_definition_record
          )
        end

        printer_definition_record.g_code_settings.start_g_code = printer_definition.g_code_settings.start_g_code
        printer_definition_record.g_code_settings.end_g_code = printer_definition.g_code_settings.end_g_code
        printer_definition_record.g_code_settings.cancel_g_code = printer_definition.g_code_settings.cancel_g_code
        printer_definition_record.g_code_settings.save!

        printer_definition_record.ulti_g_code_settings.where.not(id: printer_definition.ulti_g_code_settings.map(&:id)).destroy_all

        printer_definition.ulti_g_code_settings.each do |ulti_g_code_settings|
          ulti_g_code_settings_record = if ulti_g_code_settings.id
            printer_definition_record.ulti_g_code_settings.find_by!(
              id: ulti_g_code_settings.id,
            )
          else
            UltiGCodeSettings.new(
              printer_definition: printer_definition_record
            )
          end

          ulti_g_code_settings_record.material_id = ulti_g_code_settings.material_id
          ulti_g_code_settings_record.build_plate_temperature = ulti_g_code_settings.build_plate_temperature
          ulti_g_code_settings_record.end_of_print_retraction_length = ulti_g_code_settings.end_of_print_retraction_length
          ulti_g_code_settings_record.fan_speed = ulti_g_code_settings.fan_speed
          ulti_g_code_settings_record.flow_rate = ulti_g_code_settings.flow_rate

          %w(0_25 0_40 0_60 0_80 1_00).each do |size|
            ulti_g_code_settings_record["hotend_temperature_#{size}".to_sym] = ulti_g_code_settings.per_nozzle_settings["size_#{size}".to_sym].hotend_temperature
            ulti_g_code_settings_record["retraction_length_#{size}".to_sym] = ulti_g_code_settings.per_nozzle_settings["size_#{size}".to_sym].retraction_length
            ulti_g_code_settings_record["retraction_speed_#{size}".to_sym] = ulti_g_code_settings.per_nozzle_settings["size_#{size}".to_sym].retraction_speed
          end

          ulti_g_code_settings_record.save!
        end

        printer_definition_record.save!

        TransmitPrinterConfigurationUpdateJob.perform_later(printer_definition_record.id)

        printer_definition_record
      end
    end
  end
end
