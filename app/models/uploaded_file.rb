# frozen_string_literal: true

class UploadedFile < ApplicationRecord
  has_one_attached :file

  delegate :filename, :content_type, :byte_size, :checksum, to: :file
end
