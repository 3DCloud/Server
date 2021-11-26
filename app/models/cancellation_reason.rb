# frozen_string_literal: true

class CancellationReason < ApplicationRecord
  has_many :prints

  validates :name, presence: true, uniqueness: true
end
