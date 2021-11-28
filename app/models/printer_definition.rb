# frozen_string_literal: true

class PrinterDefinition < ApplicationRecord
  has_one_attached :thumbnail, service: Rails.configuration.active_storage.public_service
  has_many :printers, dependent: :restrict_with_error
  has_one :g_code_settings, dependent: :destroy
  has_many :ulti_g_code_settings, dependent: :destroy
  has_many :materials, through: :ulti_g_code_settings

  validates :name, uniqueness: true
  validates :filament_diameter, numericality: { greater_than: 0, less_than: 10 }
end
