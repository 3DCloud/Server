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

  validates_presence_of :printer
  validates_presence_of :uploaded_file
  validates_presence_of :started_at, if: ->(obj) { obj.status != PrintStatus::PENDING }
  validates_presence_of :completed_at, if: ->(obj) { PrintStatus::COMPLETED_STATUSES.include?(obj.status) }

  validates_inclusion_of :status, in: PrintStatus::ALL_STATUSES
end
