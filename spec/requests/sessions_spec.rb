# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  include JwtHelper

  describe 'GET /authorize' do
    it 'redirects a valid request' do
      code_challenge = Digest::SHA2.hexdigest(SecureRandom.bytes(32))

      get authorize_path, params: { code_challenge: code_challenge }

      redirect_uri = URI.parse(response.location)
      parameters = Rack::Utils.parse_query(redirect_uri.query).symbolize_keys
      relay_state = JSON.parse(parameters[:RelayState]).symbolize_keys

      expect(redirect_uri.host).to eq('makerepo.com')
      expect(redirect_uri.path).to eq('/saml/auth')
      expect(relay_state).to eq({ return: '/', code_challenge: code_challenge })
    end

    it 'redirects a valid request with a return path' do
      code_challenge = Digest::SHA2.hexdigest(SecureRandom.bytes(32))

      get authorize_path, params: { code_challenge: code_challenge, return: '/potatoes' }

      redirect_uri = URI.parse(response.location)
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

  describe 'POST /sessions/callback' do
    it 'creates a new AuthorizationGrant with the right values' do
      allow_saml_response_object

      code_challenge = '12345'
      saml_response = 'blah'
      relay_state = { return: '/potatoes', code_challenge: code_challenge }.to_json

      freeze_time do
        expect {
          post sessions_callback_path, params: { SAMLResponse: saml_response, RelayState: relay_state }
        }.to change { AuthorizationGrant.count }.by(1)

        last = AuthorizationGrant.last
        expect(last.code_challenge).to eq(code_challenge)
        expect(last.expires_at).to eq(DateTime.now.utc + 1.minute)
        expect(last.authorization_code.length).to eq(64)

        expect(response).to redirect_to("#{base_url}/potatoes#code=#{last.authorization_code}")
      end
    end

    it 'does not process invalid SAML responses' do
      allow_saml_response_object(is_valid: false)

      saml_response = 'blah'
      relay_state = { return: '/potatoes', code_challenge: '12345' }.to_json

      expect {
        post sessions_callback_path, params: { SAMLResponse: saml_response, RelayState: relay_state }
      }.to change { AuthorizationGrant.count }.by(0)

      expect(response).to have_http_status(403)
      expect(response.body).to eq({ message: 'Authentication failed' }.to_json)
    end

    it 'does not process SAML responses with the wrong name ID format' do
      allow_saml_response_object(name_id_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:emailAddress')

      saml_response = 'blah'
      relay_state = { return: '/potatoes', code_challenge: '12345' }.to_json

      expect {
        post sessions_callback_path, params: { SAMLResponse: saml_response, RelayState: relay_state }
      }.to change { AuthorizationGrant.count }.by(0).and raise_error(ActionController::BadRequest)
    end

    it 'does not process the request if the SAMLResponse param is missing' do
      relay_state = { return: '/potatoes', code_challenge: '12345' }.to_json

      expect {
        post sessions_callback_path, params: { RelayState: relay_state }
      }.to raise_error(ActionController::BadRequest)
    end

    it 'does not process the request if the RelayState param is missing' do
      saml_response = 'blah'

      expect {
        post sessions_callback_path, params: { SAMLResponse: saml_response }
      }.to raise_error(ActionController::BadRequest)
    end

    def allow_saml_response_object(
      name_id: '1234',
      name_id_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent',
      is_valid: true,
      name: 'Name',
      username: 'username000',
      email_address: 'me@example.com'
    )
      allow(OneLogin::RubySaml::Response).to receive(:new) {
        OpenStruct.new(
          name_id: name_id,
          name_id_format: name_id_format,
          is_valid?: is_valid,
          attributes: OneLogin::RubySaml::Attributes.new({
            'name' => [name],
            'username' => [username],
            'email_address' => [email_address],
          })
        )
      }
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
