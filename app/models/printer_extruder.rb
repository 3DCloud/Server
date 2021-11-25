# frozen_string_literal: true

class PrinterExtruder < ApplicationRecord
  belongs_to :printer
  belongs_to :material_color

  validates :extruder_index, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: { scope: :printer }
  validates :ulti_g_code_nozzle_size, inclusion: { in: %w(size_0_25 size_0_40 size_0_60 size_0_80 size_1_00) }, allow_nil: true
end
