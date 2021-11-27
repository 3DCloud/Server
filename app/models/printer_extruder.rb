# frozen_string_literal: true

class PrinterExtruder < ApplicationRecord
  belongs_to :printer
  belongs_to :material_color, optional: true

  validates :extruder_index, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: { scope: :printer }
  validates :ulti_g_code_nozzle_size, inclusion: { in: %w(size_0_25 size_0_40 size_0_60 size_0_80 size_1_00) }, allow_nil: true

  default_scope ->() { order(:extruder_index) }

  before_destroy do |record|
    if destroyed_by_association.is_a?(Printer) && record.extruder_index < record.printer.printer_definition.extruder_count
      errors[:base] << 'Cannot destroy extruder that is required by printer'
      throw :abort
    end
  end
end
