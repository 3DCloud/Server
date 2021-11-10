# frozen_string_literal: true

class PrinterExtruder < ApplicationRecord
  belongs_to :printer
  belongs_to :material

  validates :printer, presence: true
  validates :material, presence: true, uniqueness: { scope: [:printer, :extruder_index] }
  validates :extruder_index, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: { scope: :printer }
  validates :ulti_g_code_nozzle_size, inclusion: %w(size_0_25 size_0_40 size_0_60 size_0_80 size_1_00)
  validates :filament_diameter, presence: true, numericality: { greater_than: 0 }
end
