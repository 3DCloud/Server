# frozen_string_literal: true

class Printer < ApplicationRecord
  belongs_to :device
  belongs_to :printer_definition

  scope :for_client, ->(client_id) { joins(:device).where(device: { client_id: client_id }) }
end
