# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientChannel, type: :channel do
  let(:client) { create(:client) }

  before do
    stub_connection(client: client)
  end

  describe 'subscribed' do
    it 'successfully subscribes' do
      subscribe

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(client)
    end
  end

  describe 'device' do
    it 'creates a new device if it does not yet exist' do
      device_name = 'hello'
      hardware_identifier = SecureRandom.uuid
      is_portable_hardware_identifier = true

      subscribe

      freeze_time do
        expect {
          perform :device,
            device_name: device_name,
            hardware_identifier: hardware_identifier,
            is_portable_hardware_identifier: is_portable_hardware_identifier
        }.to change { Device.count }.by(1)

        device = Device.last
        expect(device.client).to eq(client)
        expect(device.hardware_identifier).to eq(hardware_identifier)
        expect(device.is_portable_hardware_identifier).to eq(is_portable_hardware_identifier)
        expect(device.last_seen).to eq(DateTime.now.utc)
      end
    end

    it 'updates an existing device' do
      existing_device = create(:device, client: client, last_seen: DateTime.now.utc - 5.minutes)
      new_name = 'this is my new name'

      subscribe

      freeze_time do
        expect {
          perform :device,
            device_name: new_name,
            hardware_identifier: existing_device.hardware_identifier,
            is_portable_hardware_identifier: existing_device.is_portable_hardware_identifier
        }.to change { Device.count }.by(0)

        device = Device.last
        expect(device.id).to eq(existing_device.id)
        expect(device.client).to eq(client)
        expect(device.device_name).to eq(new_name)
        expect(device.hardware_identifier).to eq(existing_device.hardware_identifier)
        expect(device.is_portable_hardware_identifier).to eq(existing_device.is_portable_hardware_identifier)
        expect(device.last_seen).to eq(DateTime.now.utc)
      end
    end

    it 'transmits the printer instance associated with the device' do
      freeze_time do
        printer = create(:printer, device: create(:device, client: client))

        subscribe

        expect {
          perform :device,
            device_name: printer.device.device_name,
            hardware_identifier: printer.device.hardware_identifier,
            is_portable_hardware_identifier: printer.device.is_portable_hardware_identifier
        }.to change { Device.count }.by(0)

        transmission = transmissions.last
        expect(transmission).to eq({
          'action' => 'printer_configuration',
          'printer' => printer.as_json(include: [:device, :printer_definition])
        })
      end
    end
  end
end
