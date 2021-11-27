# frozen_string_literal: true

class Printer < ApplicationRecord
  belongs_to :device, required: false
  belongs_to :printer_definition
  has_one :g_code_settings, through: :printer_definition
  has_many :printer_extruders, dependent: :destroy
  has_many :material_colors, through: :printer_extruders
  has_many :prints, dependent: :destroy
  belongs_to :current_print, class_name: 'Print', required: false

  validates :name, uniqueness: true

  scope :for_client, ->(client_id) { joins(:device).where(device: { client_id: client_id }) }

  alias_method :printer_extruders_raw, :printer_extruders

  def printer_extruders
    extruders = [nil] * printer_definition.extruder_count

    printer_extruders_raw.each do |extruder|
      extruders[extruder.extruder_index] = extruder
    end

    extruders
  end

  def ulti_g_code_settings
    ulti_g_code_settings = [nil] * printer_definition.extruder_count

    printer_extruders_raw
      .includes(material_color: { material: :ulti_g_code_settings })
      .where(ulti_g_code_settings: { printer_definition_id: printer_definition_id })
      .limit(printer_definition.extruder_count).each do |extruder|
      return unless extruder.ulti_g_code_nozzle_size

      nozzle_size = extruder.ulti_g_code_nozzle_size[5..] # trim size_ prefix
      ugs = extruder.material_color.material.ulti_g_code_settings.first
      ulti_g_code_settings[extruder.extruder_index] = {
        material_name: extruder.material_color.material.name,
        build_plate_temperature: ugs.build_plate_temperature,
        end_of_print_retraction_length: ugs.end_of_print_retraction_length,
        fan_speed: ugs.fan_speed,
        flow_rate: ugs.flow_rate,
        hotend_temperature: ugs["hotend_temperature_#{nozzle_size}".to_sym],
        retraction_length: ugs["retraction_length_#{nozzle_size}".to_sym],
        retraction_speed: ugs["retraction_speed_#{nozzle_size}".to_sym],
        filament_diameter: printer_definition.filament_diameter,
        created_at: ugs.created_at,
        updated_at: ugs.updated_at,
      }
    end

    ulti_g_code_settings
  end

  def state=(value)
    if value.nil?
      self.class.redis_instance.del("3dcloud:printer:#{id}:state")
    else
      self.class.redis_instance.set("3dcloud:printer:#{id}:state", value)
    end
  end

  def state
    self.class.redis_instance.get("3dcloud:printer:#{id}:state") || 'offline'
  end

  def progress=(value)
    if value.nil?
      self.class.redis_instance.del("3dcloud:printer:#{id}:progress")
    else
      self.class.redis_instance.set("3dcloud:printer:#{id}:progress", value)
    end
  end

  def progress
    self.class.redis_instance.get("3dcloud:printer:#{id}:progress")
  end

  private
    def self.redis_instance
      Redis.new(**Rails.application.config.x.redis)
    end
end
