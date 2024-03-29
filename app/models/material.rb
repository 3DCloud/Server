# frozen_string_literal: true

class Material < ApplicationRecord
  has_many :printer_extruders, dependent: :restrict_with_exception
  has_many :printers, through: :printer_extruders
  has_many :ulti_g_code_settings, dependent: :destroy
  has_many :material_colors, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: [ :brand ] }
  validates :brand, presence: true
  validates :net_filament_weight, numericality: { greater_than: 0, less_than: 100_000 }
  validates :empty_spool_weight, numericality: { greater_than: 0, less_than: 1_000 }
end
