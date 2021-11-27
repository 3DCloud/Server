# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :client
  has_one :printer, dependent: :restrict_with_error

  default_scope ->() { order(:path) }
end
