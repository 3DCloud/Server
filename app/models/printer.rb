# frozen_string_literal: true

class Printer < ApplicationRecord
  belongs_to :device
  belongs_to :printer_definition
end
