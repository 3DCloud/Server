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
      token = 'eyJhbGciOiJIUzI1NiJ9.eyJrZXkiOiJ2YWx1ZSJ9.f1O2DlUv6DdugrK9y0US9cQeB-Yt4CNl9G8mzV2GJxg'
      expected_payload = { key: 'value' }
      expect(helper.jwt_decode(token)).to eq(expected_payload)
    end

    it 'fails to validate an invalid token' do
      token = 'eyJhbGciOiJIUzI1NiJ9.eyJrZXkiOiJ2YWx1ZSJ9.f1O2DlUv6DdugrK9y0US9cQeB-Yt4cNl9G8mzV2GJxg'
      expect { helper.jwt_decode(token) }.to raise_error(JWT::VerificationError)
    end
  end
end
