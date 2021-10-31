# frozen_string_literal: true

require 'rails_helper'
require 'gcode_file'

RSpec.describe GcodeFile do
  [
    ['3DBenchy_Cura_4.11.0_GenericMarlin.gcode', 'Marlin', 4018, [3718, 0]],
    ['3DBenchy_Cura_4.11.0_Ultimaker2Plus.gcode', 'UltiGCode', 10634, [9968, 0]],
    ['3DBenchy_Cura_4.11.0_GenericMarlin_NoHeader.gcode', 'Unknown', 4166, [3755]],
  ].each do |file, flavor, estimated_duration, filament_used|
    it "calculates expected statistics for #{file}" do
      gcode_file = GcodeFile.parse_from_file(file_fixture("sample_gcode/#{file}"))

      expect(gcode_file.flavor).to eq(flavor)
      expect(gcode_file.estimated_duration).to eq(estimated_duration)
      expect(gcode_file.filament_used).to eq(filament_used)
    end
  end
end
