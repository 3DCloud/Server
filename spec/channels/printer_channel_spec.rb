# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrinterChannel, type: :channel do
  let(:client) { create(:client) }

  before do
    stub_connection(client: client)
  end

  describe 'subscribed' do
    it 'successfully subscribes when passed a valid hardware identifier' do
      printer = create(:printer, device: create(:device, client: client))

      subscribe device_path: printer.device.path

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(printer)
    end

    it 'rejects devices that are not associated to a printer' do
      device = create(:device)

      subscribe device_path: device.path

      expect(subscription).to be_rejected
    end

    it 'rejects unknown hardware IDs' do
      subscribe device_path: 'asdf1234'

      expect(subscription).to be_rejected
    end

    it 'rejects if the hardware ID is missing' do
      subscribe

      expect(subscription).to be_rejected
    end
  end

  describe 'transmit_reconnect' do
    it 'transmits a reconnect message to the specified printer' do
      printer = create(:printer, device: create(:device, client: client))
      message_id = 1234

      subscribe device_path: printer.device.path

      expect(SecureRandom).to receive(:hex).with(32).and_return(message_id)
      expect(ApplicationCable::Channel).to receive(:find_subscription).with({
        'device_path' => printer.device.path,
        'channel' => 'PrinterChannel',
      }).and_return true

      expect {
        thr = Thread.new { PrinterChannel.transmit_reconnect(printer: printer) }
        sleep(0.100)
        perform :acknowledge, 'message_id' => message_id
        thr.join
      }.to have_broadcasted_to(printer).from_channel(PrinterChannel).with({ action: 'reconnect', message_id: 1234 })
    end
  end
end
