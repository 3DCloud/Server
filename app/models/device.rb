# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :client
  has_one :printer
end
