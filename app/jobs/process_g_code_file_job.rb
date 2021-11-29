# frozen_string_literal: true

require 'gcode_file'

class ProcessGCodeFileJob < ApplicationJob
  def perform(uploaded_file_id:)
    uploaded_file = UploadedFile.includes(file_attachment: :blob).find(uploaded_file_id)
    uploaded_file.file.blob.open(tmpdir: Dir.tmpdir) do |file|
      parsed = GcodeFile.parse_from_file(file.path)
      uploaded_file.update!(
        estimated_duration: parsed.estimated_duration,
      )
    end
  end
end
