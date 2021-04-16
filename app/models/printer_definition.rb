# frozen_string_literal: true

class PrinterDefinition < ApplicationRecord
  has_many :printers, dependent: :restrict_with_error
end
