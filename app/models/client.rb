class Client < ApplicationRecord
  has_many :devices
  has_many :printers
end
