# frozen_string_literal: true

class MaterialColor < ApplicationRecord
  belongs_to :material

  validates :name, presence: true, uniqueness: { scope: :material_id }
  validates :color, presence: true, format: /\A#[A-Fa-f0-9]{3}(?:[A-Fa-f0-9]{3})?\z/
end
