# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreatePrinter, type: :request do
  include JwtHelper

  let(:query) {
    <<~GRAPHQL
      mutation($name: String!, $deviceId: ID!, $printerDefinitionId: ID!) {
        createPrinter(name: $name, deviceId: $deviceId, printerDefinitionId: $printerDefinitionId) {
          id
        }
      }
    GRAPHQL
  }

  it 'creates a new printer associated to the specified device' do
    printer_name = 'hello'
    device = create(:device)
    printer_definition = create(:printer_definition)

    expect(ClientChannel).to receive(:transmit_printer_configuration).with(anything).and_return(true)

    expect {
      execute_graphql query: query, variables: { name: printer_name, deviceId: device.id, printerDefinitionId: printer_definition.id }, user_role: 'admin'
    }.to change { Printer.count }.by(1)

    expect(response).to have_http_status(200)

    printer = Printer.last
    expect(printer.name).to eq(printer_name)
    expect(printer.device).to eq(device)
    expect(printer.printer_definition).to eq(printer_definition)

    expect(response).to have_graphql_response({
      'data' => {
        'createPrinter' => {
          'id' => printer.id.to_s
        }
      }
    })
  end
end
