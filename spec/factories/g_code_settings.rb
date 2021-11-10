# frozen_string_literal: true

FactoryBot.define do
  factory :g_code_settings do
    association :printer_definition
    cancel_g_code { "G28\nM84" }
  end
end
