# frozen_string_literal: true

class UploadedFile < ApplicationRecord
  has_one_attached :file
  belongs_to :user

  delegate :content_type, :byte_size, :checksum, :url, to: :file

  validates :ulti_g_code_nozzle_size, inclusion: %w(size_0_25 size_0_40 size_0_60 size_0_80 size_1_00), allow_nil: true

  default_scope { includes(file_attachment: :blob) }
end
