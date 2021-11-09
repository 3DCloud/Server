# frozen_string_literal: true

module Types
  class NozzleSettingsType < Types::BaseObject
    field :hotend_temperature, Int, null: false
    field :retraction_length, Float, null: false
    field :retraction_speed, Float, null: false
  end
end
