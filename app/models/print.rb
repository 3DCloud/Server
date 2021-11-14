# frozen_string_literal: true

class Print < ApplicationRecord
  module PrintStatus
    PENDING = 'pending'
    DOWNLOADING = 'downloading'
    RUNNING = 'running'
    ERRORED = 'errored'
    CANCELED = 'canceled'
    SUCCESS = 'success'

    ALL_STATUSES = [PENDING, DOWNLOADING, RUNNING, ERRORED, CANCELED, SUCCESS]
    COMPLETED_STATUSES = [ERRORED, CANCELED, SUCCESS]
  end

  belongs_to :printer
  belongs_to :uploaded_file

  validates :printer, presence: true
  validates :uploaded_file, presence: true
  validates :status, inclusion: PrintStatus::ALL_STATUSES
end
