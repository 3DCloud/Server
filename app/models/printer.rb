# frozen_string_literal: true

class Printer < ApplicationRecord
  belongs_to :client
  belongs_to :printer_definition
end
