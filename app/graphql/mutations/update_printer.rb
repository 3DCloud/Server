module Mutations
  class UpdatePrinter < BaseMutation
    type Types::PrinterType

    # TODO: define arguments
    argument :id, ID, required: true
    argument :printer, Types::PrinterInput, required: true

    # TODO: define resolve method
    def resolve(id:, printer:)
      ApplicationRecord.transaction do
        printer_record = Printer.includes(:printer_extruders, :printer_definition).find(id)

        if printer_record.printer_definition.extruder_count != printer.printer_extruders.length
          raise 'Unexpected number of extruders'
        end

        printer.printer_extruders.each do |extruder|
          extruder_record = printer_record.printer_extruders.find { |ext| ext.extruder_index == extruder.extruder_index } || PrinterExtruder.new(printer: printer_record, extruder_index: extruder.extruder_index)
          extruder_record.update!(
            ulti_g_code_nozzle_size: extruder.ulti_g_code_nozzle_size
          )
        end

        printer_record
      end
    end
  end
end
