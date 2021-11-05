# frozen_string_literal: true

class GCodeSettings < ApplicationRecord
  belongs_to :printer_definition

  validates :printer_definition, presence: true
end
