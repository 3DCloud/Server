# frozen_string_literal: true

class UltiGCodeSettings < ApplicationRecord
  belongs_to :printer_definition
  belongs_to :material

  validates :printer_definition, presence: true
  validates :material, presence: true, uniqueness: { scope: :printer_definition }
  validates :build_plate_temperature, presence: true, numericality: { only_integer: true }
  validates :end_of_print_retraction_length, presence: true
  validates :fan_speed, presence: true, inclusion: 0..150
  validates :flow_rate, presence: true, inclusion: 0..150

  validates :hotend_temperature_0_25, presence: true, numericality: { only_integer: true }
  validates :retraction_length_0_25, presence: true
  validates :retraction_speed_0_25, presence: true

  validates :hotend_temperature_0_40, presence: true, numericality: { only_integer: true }
  validates :retraction_length_0_40, presence: true
  validates :retraction_speed_0_40, presence: true

  validates :hotend_temperature_0_60, presence: true, numericality: { only_integer: true }
  validates :retraction_length_0_60, presence: true
  validates :retraction_speed_0_60, presence: true

  validates :hotend_temperature_0_80, presence: true, numericality: { only_integer: true }
  validates :retraction_length_0_80, presence: true
  validates :retraction_speed_0_80, presence: true

  validates :hotend_temperature_1_00, presence: true, numericality: { only_integer: true }
  validates :retraction_length_1_00, presence: true
  validates :retraction_speed_1_00, presence: true
end
