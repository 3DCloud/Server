# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  include JwtHelper

  describe 'GET /authorize' do
    it 'redirects a valid request' do
      code_challenge = Digest::SHA2.hexdigest(SecureRandom.bytes(32))

      get authorize_path, params: { code_challenge: code_challenge }

      redirect_uri = URI.parse(response.headers['Location'])
      parameters = Rack::Utils.parse_query(redirect_uri.query).symbolize_keys
      relay_state = JSON.parse(parameters[:RelayState]).symbolize_keys

      expect(redirect_uri.host).to eq('makerepo.com')
      expect(redirect_uri.path).to eq('/saml/auth')
      expect(relay_state).to eq({ return: '/', code_challenge: code_challenge })
    end

    it 'redirects a valid request with a return path' do
      code_challenge = Digest::SHA2.hexdigest(SecureRandom.bytes(32))

      get authorize_path, params: { code_challenge: code_challenge, return: '/potatoes' }

      redirect_uri = URI.parse(response.headers['Location'])
      parameters = Rack::Utils.parse_query(redirect_uri.query).symbolize_keys
      relay_state = JSON.parse(parameters[:RelayState]).symbolize_keys

      expect(relay_state).to eq({ return: '/potatoes', code_challenge: code_challenge })
    end

    it 'responds with Bad Request if code challenge is not the right length' do
      expect {
        get authorize_path, params: { code_challenge: 'abcdefg' }
      }.to raise_error(ActionController::BadRequest)
    end

    it 'responds with Bad Request if code challenge is missing' do
      expect {
        get authorize_path
      }.to raise_error(ActionController::BadRequest)
    end
  end

  describe 'POST /logout' do
    it 'deletes the session associated with the passed token' do
      jti = SecureRandom.hex(32)
      session = create(:session, jti: jti)

      token = jwt_encode(jti: jti)

      post logout_path, params: { token: token }

      expect(response).to have_http_status(204)
      expect(Session.find_by(id: session.id)).to be_nil
    end

    it 'does not delete other sessions' do
      jti1 = SecureRandom.hex(32)
      jti2 = SecureRandom.hex(32)
      session = create(:session, jti: jti1)

      token = jwt_encode(jti: jti2)

      post logout_path, params: { token: token }

      expect(response).to have_http_status(204)
      expect(Session.find_by(id: session.id)).to_not be_nil
    end

    it 'returns Bad Request if no token is passed' do
      expect {
        post logout_path
      }.to raise_error(ActionController::BadRequest)
    end

    it 'returns Bad Request if garbage is passed as the token' do
      expect {
        post logout_path, params: { token: 'nonsense' }
      }.to raise_error(ActionController::BadRequest)
    end
  end
end
