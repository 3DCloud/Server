# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrinterChannel, type: :channel do
  describe 'subscribed' do
    it 'successfully subscribes when passed a valid hardware identifier' do
      printer = create(:printer)

      subscribe hardware_identifier: printer.device.hardware_identifier

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(printer)
    end

    it 'rejects devices that are not associated to a printer' do
      device = create(:device)

      subscribe hardware_identifier: device.hardware_identifier

      expect(subscription).to be_rejected
    end

    it 'rejects unknown hardware IDs' do
      subscribe hardware_identifier: 'asdf1234'

      expect(subscription).to be_rejected
    end

    it 'rejects if the hardware ID is missing' do
      subscribe

      expect(subscription).to be_rejected
    end
  end

  describe 'transmit_reconnect' do
    it 'transmits a reconnect message to the specified printer' do
      printer = create(:printer)

      expect {
        PrinterChannel.transmit_reconnect(printer: printer)
      }.to have_broadcasted_to(printer).from_channel(PrinterChannel).with({ action: 'reconnect' })
    end
  end
end
