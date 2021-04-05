# frozen_string_literal: true

class ClientsChannel < ApplicationCable::Channel
  def subscribed
    reject unless params.key?("guid")

    @client = Client.find_by_id(params["guid"])
    @key = params.fetch("key", nil)

    if @client.nil?
      @client = Client.new(id: params["guid"])
      @client.save!
    end

    stream_for "all"
    stream_for @client
  end

  def device(args)
    return unless @key.present?
    return unless args.key?("device_name") && args.key?("device_id") && args.key?("is_portable_device_id")

    device = Device.find_by_hardware_identifier(args["device_id"])

    if device.nil?
      device = Device.new(device_name: args["device_name"], hardware_identifier: args["device_id"], is_portable_device_id: args["is_portable_device_id"])
    end

    device.client = @client
    device.last_seen = Time.now
    device.save!

    printer = Printer.includes(:device, :printer_definition).where(device: { hardware_identifier: args["device_id"] }).first

    if printer.present?
      transmit({ action: "printer_configuration", printer: printer.as_json(include: [:device, :printer_definition]) })
    end
  end

  def printer_states(args)
    args["printer_states"].each do |key, value|
      logger.info "#{key} -- #{value}"
    end
  end
end
