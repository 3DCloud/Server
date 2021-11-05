# frozen_string_literal: true

class MaterialColor < ApplicationRecord
  belongs_to :material
  validates :name, presence: true
  validates :color, presence: true, format: /\A[A-Fa-f0-9]{6}\z/
end
