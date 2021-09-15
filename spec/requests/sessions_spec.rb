# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  include JwtHelper
  include ERB::Util

  describe 'GET /authorize' do
    it 'redirects a valid request' do
      code_challenge = Digest::SHA2.hexdigest(SecureRandom.bytes(32))

      get sessions_authorize_path, params: { code_challenge: code_challenge }

      redirect_uri = URI.parse(response.location)
      parameters = Rack::Utils.parse_query(redirect_uri.query).symbolize_keys
      relay_state = JSON.parse(parameters[:RelayState]).symbolize_keys

      expect(redirect_uri.host).to eq('makerepo.com')
      expect(redirect_uri.path).to eq('/saml/auth')
      expect(relay_state).to eq({ return: '/', code_challenge: code_challenge })
    end

    it 'redirects a valid request with a return path' do
      code_challenge = Digest::SHA2.hexdigest(SecureRandom.bytes(32))

      get sessions_authorize_path, params: { code_challenge: code_challenge, return: '/potatoes' }

      redirect_uri = URI.parse(response.location)
      parameters = Rack::Utils.parse_query(redirect_uri.query).symbolize_keys
      relay_state = JSON.parse(parameters[:RelayState]).symbolize_keys

      expect(relay_state).to eq({ return: '/potatoes', code_challenge: code_challenge })
    end

    it 'responds with Bad Request if code challenge is not the right length' do
      get sessions_authorize_path, params: { code_challenge: 'abcdefg' }

      expect(response).to have_http_status(400)
    end

    it 'responds with Bad Request if code challenge is missing' do
      get sessions_authorize_path

      expect(response).to have_http_status(400)
    end
  end

  describe 'POST /sessions/callback' do
    it 'creates a new AuthorizationGrant with the right values' do
      allow_saml_response_object

      code_challenge = '12345'
      saml_response = 'blah'
      relay_state = { return: '/potatoes', code_challenge: code_challenge }

      freeze_time do
        expect {
          post sessions_callback_path, params: { SAMLResponse: saml_response, RelayState: relay_state.to_json }
        }.to change { AuthorizationGrant.count }.by(1)

        last = AuthorizationGrant.last
        expect(last.code_challenge).to eq(code_challenge)
        expect(last.expires_at).to eq(DateTime.now.utc + 1.minute)
        expect(last.authorization_code.length).to eq(64)

        expect(response).to redirect_to("http://localhost:4200/auth/callback?code=#{url_encode(last.authorization_code)}&return=#{url_encode(relay_state[:return])}")
      end
    end

    it 'does not process invalid SAML responses' do
      allow_saml_response_object(is_valid: false)

      saml_response = 'blah'
      relay_state = { return: '/potatoes', code_challenge: '12345' }.to_json

      expect {
        post sessions_callback_path, params: { SAMLResponse: saml_response, RelayState: relay_state }
      }.to change { AuthorizationGrant.count }.by(0)

      expect(response).to have_http_status(401)
    end

    it 'does not process SAML responses with the wrong name ID format' do
      allow_saml_response_object(name_id_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:emailAddress')

      saml_response = 'blah'
      relay_state = { return: '/potatoes', code_challenge: '12345' }.to_json

      expect {
        post sessions_callback_path, params: { SAMLResponse: saml_response, RelayState: relay_state }
      }.to change { AuthorizationGrant.count }.by(0)

      expect(response).to have_http_status(400)
    end

    it 'does not process the request if the SAMLResponse param is missing' do
      relay_state = { return: '/potatoes', code_challenge: '12345' }.to_json

      post sessions_callback_path, params: { RelayState: relay_state }

      expect(response).to have_http_status(400)
    end

    it 'does not process the request if the RelayState param is missing' do
      saml_response = 'blah'

      post sessions_callback_path, params: { SAMLResponse: saml_response }

      expect(response).to have_http_status(400)
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

  describe 'POST /sessions/token' do
    it 'processes valid authorization_code requests' do
      code_verifier = 'abcd1234'
      code_challenge = sha256(code_verifier)

      grant = create(:authorization_grant, code_challenge: code_challenge)

      freeze_time do
        expect {
          post sessions_token_path, params: { grant_type: 'authorization_code', code_verifier: code_verifier, code: grant.authorization_code }
        }.to change { AuthorizationGrant.count }.by(-1).and change { Session.count }.by(1)

        body = JSON.parse(response.body).symbolize_keys
        access_token = jwt_decode(body[:access_token])
        refresh_token = jwt_decode(body[:refresh_token])

        expect(body[:token_type]).to eq('bearer')
        expect(body[:expires_in]).to eq(15.minutes)

        expect(access_token[:iss]).to eq(jwt_issuer)
        expect(access_token[:jti].length).to eq(64)
        expect(access_token[:exp]).to eq((DateTime.now.utc + 15.minutes).to_i)
        expect(access_token[:sub]).to eq(grant.user.id)

        expect(refresh_token[:iss]).to eq(jwt_issuer)
        expect(refresh_token[:jti].length).to eq(64)
        expect(refresh_token[:exp]).to eq((DateTime.now.utc + 14.days).to_i)
        expect(refresh_token[:sub]).to eq(grant.user.id)

        session = Session.last
        expect(session.user).to eq(grant.user)
        expect(session.jti).to eq(refresh_token[:jti])
        expect(session.expires_at).to eq(DateTime.now.utc + 14.days)
      end
    end

    it 'processes valid refresh_token requests' do
      jti = SecureRandom.hex(32)
      old_session = create(:session, jti: jti)
      refresh_token = jwt_encode(
        iss: jwt_issuer,
        jti: jti,
        exp: (DateTime.now.utc + 5.minutes).to_i,
        sub: old_session.user.id,
      )

      freeze_time do
        post sessions_token_path, params: { grant_type: 'refresh_token', refresh_token: refresh_token }

        body = JSON.parse(response.body).symbolize_keys
        access_token = jwt_decode(body[:access_token])
        refresh_token = jwt_decode(body[:refresh_token])

        expect(body[:token_type]).to eq('bearer')
        expect(body[:expires_in]).to eq(15.minutes)

        expect(access_token[:iss]).to eq(jwt_issuer)
        expect(access_token[:jti].length).to eq(64)
        expect(access_token[:exp]).to eq((DateTime.now.utc + 15.minutes).to_i)
        expect(access_token[:sub]).to eq(old_session.user.id)

        expect(refresh_token[:iss]).to eq(jwt_issuer)
        expect(refresh_token[:jti].length).to eq(64)
        expect(refresh_token[:exp]).to eq((DateTime.now.utc + 14.days).to_i)
        expect(refresh_token[:sub]).to eq(old_session.user.id)

        session = Session.last
        expect(session.id).to_not eq(old_session.id)
        expect(session.jti).to_not eq(old_session.jti)
        expect(session.user).to eq(old_session.user)
        expect(session.jti).to eq(refresh_token[:jti])
        expect(session.expires_at).to eq(DateTime.now.utc + 14.days)
      end
    end

    it 'does not process requests with no grant_type' do
      post sessions_token_path, params: { code_verifier: 'abcd1234', code: 'efgh5678' }

      expect(response).to have_http_status(400)
    end

    it 'does not process requests with an invalid grant_type' do
      post sessions_token_path, params: { grant_type: 'authorisation_code', code_verifier: 'abcd1234', code: 'efgh5678' }

      expect(response).to have_http_status(400)
    end

    it 'does not process authorization_code requests if code_verifier is missing from the parameters' do
      post sessions_token_path, params: { grant_type: 'authorization_code', code: 'efgh5678' }

      expect(response).to have_http_status(400)
    end

    it 'does not process authorization_code requests if code is missing from the parameters' do
      post sessions_token_path, params: { grant_type: 'authorization_code', code_verifier: 'abcd1234' }

      expect(response).to have_http_status(400)
    end

    it 'does not process expired authorization grants' do
      code_verifier = 'abcd1234'
      code_challenge = sha256(code_verifier)

      grant = create(:authorization_grant, code_challenge: code_challenge, expires_at: DateTime.now - 1.second)

      expect {
        post sessions_token_path, params: { grant_type: 'authorization_code', code_verifier: code_verifier, code: grant.authorization_code }
      }.to change { AuthorizationGrant.count }.by(0)
       .and change { Session.count }.by(0)

      expect(response).to have_http_status(400)
    end

    it 'does not process refresh_token requests if refresh_token is missing from the parameters' do
      post sessions_token_path, params: { grant_type: 'refresh_token' }

      expect(response).to have_http_status(400)
    end

    it 'does not process expired refresh tokens' do
      jti = SecureRandom.hex(32)
      expires_at = DateTime.now.utc - 1.second
      session = create(:session, jti: jti, expires_at: expires_at)
      refresh_token = jwt_encode(
        iss: jwt_issuer,
        jti: jti,
        exp: expires_at.to_i,
        sub: session.user.id,
      )

      expect {
        post sessions_token_path, params: { grant_type: 'refresh_token', refresh_token: refresh_token }
      }.to change { Session.count }.by(0)

      expect(response).to have_http_status(400)
    end
  end

  describe 'POST /logout' do
    it 'deletes the session associated with the passed token' do
      jti = SecureRandom.hex(32)
      session = create(:session, jti: jti)

      token = jwt_encode(
        iss: jwt_issuer,
        jti: jti
      )

      expect {
        post sessions_logout_path, params: { token: token }
      }.to change { Session.count }.by(-1)

      expect(response).to have_http_status(204)
      expect(Session.find_by(id: session.id)).to be_nil
    end

    it 'does not delete other sessions' do
      jti1 = SecureRandom.hex(32)
      jti2 = SecureRandom.hex(32)
      session = create(:session, jti: jti1)

      token = jwt_encode(
        iss: jwt_issuer,
        jti: jti2
      )

      post sessions_logout_path, params: { token: token }

      expect(response).to have_http_status(204)
      expect(Session.find_by(id: session.id)).to_not be_nil
    end

    it 'returns Bad Request if no token is passed' do
      post sessions_logout_path

      expect(response).to have_http_status(400)
    end

    it 'returns Bad Request if garbage is passed as the token' do
      post sessions_logout_path, params: { token: 'nonsense' }

      expect(response).to have_http_status(400)
    end
  end

  def sha256(message)
    Digest::SHA2.new(256).hexdigest(message)
  end
end
