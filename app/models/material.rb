# frozen_string_literal: true

class Material < ApplicationRecord
  has_many :printer_materials
  has_many :printers, through: :printer_materials
  has_many :ulti_g_code_settings

  validates :name, presence: true
  validates :brand, presence: true
  validates :filament_diameter, numericality: { greater_than: 0, less_than: 10 }
  validates :net_filament_weight, numericality: { greater_than: 0, less_than: 100_000 }
  validates :empty_spool_weight, numericality: { greater_than: 0, less_than: 1_000 }
end
