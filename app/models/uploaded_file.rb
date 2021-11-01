# frozen_string_literal: true

class UploadedFile < ApplicationRecord
  has_one_attached :file
  belongs_to :user

  delegate :filename, :content_type, :byte_size, :checksum, to: :file

  default_scope { includes(file_attachment: :blob).order(created_at: :desc) }

  def estimated_duration
    file.metadata[:estimated_duration]
  end
end
