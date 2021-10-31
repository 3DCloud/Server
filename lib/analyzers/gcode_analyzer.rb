# frozen_string_literal: true

require 'gcode_file'

module Analyzers
  class GcodeAnalyzer < ActiveStorage::Analyzer
    def self.accept?(blob)
      blob.filename.extension == 'gcode' && %w(text/plain text/x.gcode text/x-gcode application/octet-stream).include?(blob.content_type)
    end

    def metadata
      parse_file do |gcode_file|
        gcode_file.to_hash
      end
    end

    private
      def parse_file
        download_blob_to_tempfile do |file|
          yield GcodeFile.parse_from_file(file.path)
        end
      end
  end
end
