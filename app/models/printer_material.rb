# frozen_string_literal: true

class PrinterMaterial < ApplicationRecord
  belongs_to :printer
  belongs_to :material

  validates :printer, presence: true
  validates :material, presence: true
  validates :extruder_index, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: { scope: :printer }
end
