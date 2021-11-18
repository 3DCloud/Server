# frozen_string_literal: true

class PrinterDefinition < ApplicationRecord
  has_many :printers, dependent: :restrict_with_error
  has_one :g_code_settings, dependent: :destroy
  has_many :ulti_g_code_settings, dependent: :destroy
  has_many :materials, through: :ulti_g_code_settings

  validates :name, uniqueness: true
end
