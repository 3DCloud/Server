# frozen_string_literal: true

module Mutations
  class ChangeMaterial < BaseMutation
    type Types::PrinterExtruderType

    argument :printer_id, ID, required: true
    argument :extruder_index, Int, required: true
    argument :material_color_id, ID, required: true
    argument :weight, Int, required: false

    def resolve(printer_id:, extruder_index:, material_color_id:, weight: nil)
      printer_extruder = PrinterExtruder.find_by(printer_id: printer_id, extruder_index: extruder_index)

      if printer_extruder
        authorize!(:update, printer_extruder)
      else
        authorize!(:create, PrinterExtruder)
        printer_extruder = PrinterExtruder.new(printer_id: printer_id, extruder_index: extruder_index)
      end

      printer_extruder.update!(
        material_color_id: material_color_id,
      )

      TransmitPrinterConfigurationUpdateJob.perform_later(printer_id: printer_extruder.printer_id)

      printer_extruder
    end
  end
end
