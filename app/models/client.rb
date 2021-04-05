# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :devices
  has_many :printers
end
