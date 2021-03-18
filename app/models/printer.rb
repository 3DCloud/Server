class Printer < ApplicationRecord
  belongs_to :client
  belongs_to :printer_definition
end
