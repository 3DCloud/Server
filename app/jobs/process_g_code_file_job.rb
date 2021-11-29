# frozen_string_literal: true

require 'gcode_file'

class ProcessGCodeFileJob < ApplicationJob
  def perform(uploaded_file_id:)
    uploaded_file = UploadedFile.includes(file_attachment: :blob).find(uploaded_file_id)
    uploaded_file.file.blob.open(tmpdir: Dir.tmpdir) do |file|
      parsed = GcodeFile.parse_from_file(file.path)

      uploaded_file.estimated_duration = parsed.estimated_duration
      uploaded_file.ulti_g_code_nozzle_size = "size_#{sprintf("%.2f", parsed.nozzle_diameters[0]).gsub('.', '_')}" if parsed.flavor == 'UltiGCode'

      uploaded_file.save!
    end
  end
end
