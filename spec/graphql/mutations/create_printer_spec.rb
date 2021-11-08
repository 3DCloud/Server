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

    expect {
      execute_graphql query: query, variables: { name: printer_name, deviceId: device.id, printerDefinitionId: printer_definition.id }
    }.to change { Printer.count }.by(1)

    expect(response).to have_http_status(200)

    printer = Printer.last
    expect(printer.name).to eq(printer_name)
    expect(printer.device).to eq(device)
    expect(printer.printer_definition).to eq(printer_definition)

    # we can't use expect { ... }.to have_broadcasted_to.with since `printer` is created inside the block
    expect(ClientChannel).to have_broadcasted_message(device.client, {
      'action' => 'printer_configuration',
      'printer' => printer.as_json(include: [:device, :printer_definition])
    })

    expect(response).to have_graphql_response(
      'id' => printer.id.to_s
    )
  end
end
