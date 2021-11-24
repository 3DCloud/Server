# frozen_string_literal: true

module Types
  class PrinterExtruderInput < Types::BaseInputObject
    argument :extruder_index, Int, required: true
    argument :ulti_g_code_nozzle_size, String, required: false
  end
end
