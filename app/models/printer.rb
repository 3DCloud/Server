# frozen_string_literal: true

class Printer < ApplicationRecord
  belongs_to :device
  belongs_to :printer_definition
  has_one :g_code_settings, through: :printer_definition
  has_many :printer_materials
  has_many :materials, through: :printer_materials
  has_many :prints
  belongs_to :current_print, class_name: 'Print', required: false

  validates :state, inclusion: %w(disconnected connecting ready downloading disconnecting busy heating printing pausing paused resuming canceling errored offline)

  scope :for_client, ->(client_id) { joins(:device).where(device: { client_id: client_id }) }

  def ulti_g_code_settings
    UltiGCodeSettings
      .joins(printer_definition: [ :printers ], material: [ :printer_materials ])
      .where(printer_materials: { printer_id: id })
      .merge(PrinterMaterial.order(extruder_index: :asc))
  end
end
