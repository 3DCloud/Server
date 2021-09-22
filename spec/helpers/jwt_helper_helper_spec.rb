# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtHelper, type: :helper do
  describe 'jwt_encode' do
    it 'encodes a payload using app configuration' do
      payload = { key: 'value' }
      expect(helper.jwt_encode(**payload)).to eq(JWT.encode(
        { **payload, iss: Rails.configuration.x.jwt.issuer },
        Rails.configuration.x.jwt.encode_key,
        Rails.configuration.x.jwt.algorithm
      ))
    end

    it 'overwrites a passed iss parameter' do
      payload = { key: 'value', iss: 'garbage' }
      expect(helper.jwt_encode(**payload)).to eq(JWT.encode(
        { **payload, iss: Rails.configuration.x.jwt.issuer },
        Rails.configuration.x.jwt.encode_key,
        Rails.configuration.x.jwt.algorithm
      ))
    end
  end

  describe 'jwt_decode' do
    it 'decodes a valid token and returns the payload' do
      expected_payload = { key: 'value', iss: Rails.configuration.x.jwt.issuer }
      token = JWT.encode(expected_payload, Rails.configuration.x.jwt.encode_key, Rails.configuration.x.jwt.algorithm)
      expect(helper.jwt_decode_and_verify(token)).to eq(expected_payload)
    end

    it 'fails to validate if the issuer is wrong' do
      token = JWT.encode({ key: 'value', iss: 'nonsense' }, Rails.configuration.x.jwt.encode_key, Rails.configuration.x.jwt.algorithm)
      expect { helper.jwt_decode_and_verify(token) }.to raise_error(JWT::InvalidIssuerError)
    end

    it 'fails to validate if the issuer is missing' do
      token = JWT.encode({ key: 'value' }, Rails.configuration.x.jwt.encode_key, Rails.configuration.x.jwt.algorithm)
      expect { helper.jwt_decode_and_verify(token) }.to raise_error(JWT::InvalidIssuerError)
    end
  end
end
