class ClientsChannel < ApplicationCable::Channel
  def subscribed
    reject unless params.key?("guid")

    @client = Client.find_by_uuid(params["guid"])
    @key = params.fetch("key", nil)

    stream_for "all"
    stream_for @client

    if @client.nil?
      @client = Client.new(uuid: params["guid"])
      @client.save!
    end

    # TODO this should be done when admin accepts through UI
    if @key.blank?
      @key = SecureRandom.base58 32
      transmit({ action: "auth_key", key: @key })
    end
  end

  def device(args)
    return unless args.key?("device_name") && args.key?("device_id") && args.key?("is_portable_device_id")

    device = Device.find_by_device_id(args["device_id"])

    if device.nil?
      device = Device.new(device_name: args["device_name"], device_id: args["device_id"], is_portable_device_id: args["is_portable_device_id"])
    end

    device.client = @client
    device.last_seen = Time.now
    device.save!

    printer = Printer.includes(:printer_definition).where(device_id: args["device_id"]).references(:printer_definition).first

    if printer.present?
      transmit({ action: "printer_configuration", printer: printer.as_json(include: :printer_definition) })
    end
  end
end