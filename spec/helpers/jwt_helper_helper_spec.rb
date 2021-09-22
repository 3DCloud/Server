# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtHelper, type: :helper do
  describe 'jwt_issuer' do
    it 'returns the expected issuer name' do
      expect(helper.jwt_issuer).to eq(Rails.configuration.x.jwt.issuer)
    end
  end

  describe 'jwt_encode' do
    it 'encodes a payload using app configuration' do
      payload = { key: 'value' }
      expect(helper.jwt_encode(**payload)).to eq(JWT.encode(payload, Rails.application.secrets.dig(:jwt_secret), Rails.configuration.x.jwt.algorithm))
    end
  end

  describe 'jwt_decode' do
    it 'decodes a valid token and returns the payload' do
      token = 'eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIzZGNsb3VkLXRlc3QifQ.dN2ur771sQ6-2L8LXSbEagVCGVUAIqTwq1sb6O9tlDg'
      expected_payload = { iss: Rails.configuration.x.jwt.issuer }
      expect(helper.jwt_decode_and_verify(token)).to eq(expected_payload)
    end

    it 'fails to validate if the issuer is wrong' do
      # issuer is set to 'nonsense'
      token = 'eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJub25zZW5zZSJ9.z6QnRrNNsWOLbrVaRnXMS9-kwYOsXqf26oorVBKa7Vw'
      expect { helper.jwt_decode_and_verify(token) }.to raise_error(JWT::InvalidIssuerError)
    end

    it 'fails to validate a token with an invalid signature' do
      # changed a character in the signature (after 2nd .)
      token = 'eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIzZGNsb3VkLXRlc3QifQ.dN2ur771sQ6-2L8LXSbEagVQGVUAIqTwq1sb6O9tlDg'
      expect { helper.jwt_decode_and_verify(token) }.to raise_error(JWT::VerificationError)
    end
  end
end
