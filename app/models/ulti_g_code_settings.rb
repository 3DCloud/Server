# frozen_string_literal: true

class UltiGCodeSettings < ApplicationRecord
  belongs_to :printer_definition
  belongs_to :material

  validates :printer_definition, presence: true
  validates :material, presence: true, uniqueness: { scope: :printer }
  validates :hotend_temperature, presence: true, numericality: { only_integer: true }
  validates :build_plate_temperature, presence: true, numericality: { only_integer: true }
  validates :retraction_length, presence: true
  validates :end_of_print_retraction_length, presence: true
  validates :retraction_speed, presence: true, numericality: { only_integer: true }
  validates :fan_speed, presence: true, inclusion: 0..100
  validates :flow_rate, presence: true, inclusion: 0..100
end
