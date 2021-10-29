# frozen_string_literal: true

class Printer < ApplicationRecord
  belongs_to :device
  belongs_to :printer_definition
  has_many :prints
  belongs_to :current_print, class_name: 'Print', required: false

  validates :state, inclusion: %w(disconnected connecting ready downloading disconnecting busy heating printing pausing paused resuming canceling errored offline)

  scope :for_client, ->(client_id) { joins(:device).where(device: { client_id: client_id }) }
end
