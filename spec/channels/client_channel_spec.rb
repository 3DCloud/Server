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
      device_path = 'some/path'
      serial_number = SecureRandom.uuid

      subscribe

      freeze_time do
        expect {
          perform :device,
            name: device_name,
            path: device_path,
            serial_number: serial_number
        }.to change { Device.count }.by(1)

        device = Device.last
        expect(device.client).to eq(client)
        expect(device.name).to eq(device_name)
        expect(device.path).to eq(device_path)
        expect(device.serial_number).to eq(serial_number)
        expect(device.last_seen).to eq(DateTime.now.utc)
      end
    end

    it 'updates an existing device when a serial number is given' do
      existing_device = create(:device, client: client, last_seen: DateTime.now.utc - 5.minutes, serial_number: SecureRandom.hex)
      new_name = 'this is my new name'

      subscribe

      freeze_time do
        expect {
          perform :device,
            name: new_name,
            path: '/some/new/path',
            serial_number: existing_device.serial_number
        }.to change { Device.count }.by(0)

        device = Device.last
        expect(device.id).to eq(existing_device.id)
        expect(device.client).to eq(client)
        expect(device.name).to eq(new_name)
        expect(device.path).to eq(existing_device.path)
        expect(device.serial_number).to eq(existing_device.serial_number)
        expect(device.last_seen).to eq(DateTime.now.utc)
      end
    end

    it 'updates an existing device when no serial number is given' do
      existing_device = create(:device, client: client, last_seen: DateTime.now.utc - 5.minutes)
      new_name = 'this is my new name'

      subscribe

      freeze_time do
        expect {
          perform :device,
            name: new_name,
            path: existing_device.path
        }.to change { Device.count }.by(0)

        device = Device.last
        expect(device.id).to eq(existing_device.id)
        expect(device.client).to eq(client)
        expect(device.name).to eq(new_name)
        expect(device.path).to eq(existing_device.path)
        expect(device.serial_number).to eq(existing_device.serial_number)
        expect(device.last_seen).to eq(DateTime.now.utc)
      end
    end

    it 'transmits the printer instance associated with the device' do
      freeze_time do
        printer = create(:printer, device: create(:device, client: client))
        create(:g_code_settings, printer_definition: printer.printer_definition)
        material1 = create(:material)
        material2 = create(:material)
        create(:printer_extruder, printer: printer, material: material1, extruder_index: 0, ulti_g_code_nozzle_size: 'size_0_60')
        create(:printer_extruder, printer: printer, material: material2, extruder_index: 1, ulti_g_code_nozzle_size: 'size_1_00')
        create(:ulti_g_code_settings, material: material1, printer_definition: printer.printer_definition)
        create(:ulti_g_code_settings, material: material2, printer_definition: printer.printer_definition)

        subscribe

        expect {
          perform :device,
            name: printer.device.name,
            path: printer.device.path,
            serial_number: printer.device.serial_number
        }.to change { Device.count }.by(0)

        transmission = transmissions.last
        expect(transmission).to eq({
          'action' => 'printer_configuration',
          'printer' => printer.as_json.merge(
            'device' => printer.device.as_json,
            'printer_definition' => printer.printer_definition.as_json.merge(
              'g_code_settings' => printer.printer_definition.g_code_settings.as_json
            ),
            'ulti_g_code_settings' => printer.ulti_g_code_settings.as_json
          )
        })
      end
    end
  end
end
