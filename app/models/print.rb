# frozen_string_literal: true

class Print < ApplicationRecord
  module PrintStatus
    PENDING = 'pending'
    DOWNLOADING = 'downloading'
    RUNNING = 'running'
    CANCELING = 'canceling'
    ERRORED = 'errored'
    CANCELED = 'canceled'
    SUCCESS = 'success'

    ALL_STATUSES = [PENDING, DOWNLOADING, RUNNING, CANCELING, ERRORED, CANCELED, SUCCESS]
    COMPLETED_STATUSES = [ERRORED, CANCELED, SUCCESS]
  end

  belongs_to :printer
  belongs_to :uploaded_file
  belongs_to :canceled_by, class_name: 'User', optional: true
  belongs_to :cancellation_reason, optional: true

  validates :status, inclusion: PrintStatus::ALL_STATUSES
  validates :cancellation_reason, presence: true, if: ->(obj) { [PrintStatus::CANCELING, PrintStatus::CANCELED].include?(obj.status) && obj.cancellation_reason_details.blank? }
  validates :cancellation_reason_details, presence: true, if: ->(obj) { [PrintStatus::CANCELING, PrintStatus::CANCELED].include?(obj.status) && obj.cancellation_reason.blank? }

  delegate :user_id, to: :uploaded_file
end
