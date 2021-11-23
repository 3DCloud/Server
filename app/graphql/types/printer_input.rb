# frozen_string_literal: true

module Types
  class PrinterInput < Types::BaseInputObject
    argument :printer_extruders, [PrinterExtruderInput], required: true
  end
end
