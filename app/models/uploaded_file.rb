# frozen_string_literal: true

class UploadedFile < ApplicationRecord
  has_one_attached :file
  belongs_to :user

  delegate :content_type, :byte_size, :checksum, :url, to: :file

  default_scope { includes(file_attachment: :blob) }
end
