# frozen_string_literal: true

class SessionsController < ApplicationController
  include ERB::Util

  SAML_SETTINGS_CACHE_KEY = 'saml_settings'
  SAML_SETTINGS_CACHE_DURATION = 1.minute

  skip_before_action :verify_access_token

  def new
    raise ActionController::BadRequest unless params.has_key?(:code_challenge) && params[:code_challenge].length == 64

    request = OneLogin::RubySaml::Authrequest.new
    relay_state = {
      return: params[:return] || '/',
      code_challenge: params[:code_challenge],
    }.to_json

    redirect_to request.create(saml_settings, RelayState: relay_state)
  end

  def create
    raise ActionController::BadRequest unless params.has_key?(:SAMLResponse) && params.has_key?(:RelayState)

    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse].to_s, settings: saml_settings)

    unless response.name_id_format == 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent'
      raise ActionController::BadRequest.new "Unexpected name ID format #{response.name_id_format}"
    end

    raise Unauthorized unless response.is_valid?

    relay_state = JSON.parse(params[:RelayState]).symbolize_keys
    code_challenge = relay_state[:code_challenge]
    authorization_code = SecureRandom.hex(32)

    AuthorizationGrant.new(
      user: User.get_or_create_from_saml_response(response.name_id, response.attributes),
      code_challenge: code_challenge,
      authorization_code: authorization_code,
      expires_at: DateTime.now.utc + 1.minute
    ).save!

    redirect_to "http://localhost:4200/auth/callback?#{{ code: authorization_code, return: relay_state[:return] }.to_query}"
  end

  def token
    raise ActionController::BadRequest unless params.has_key?(:grant_type)

    case params[:grant_type]
    when 'authorization_code'
      raise ActionController::BadRequest unless params.has_key?(:code_verifier) && params.has_key?(:code)

      grant = AuthorizationGrant.find_by!(code_challenge: sha256(params[:code_verifier]), authorization_code: params[:code], expires_at: DateTime.now.utc..)
      user = grant.user
      grant.destroy!
    when 'refresh_token'
      raise ActionController::BadRequest unless params.has_key?(:refresh_token)

      token_contents = jwt_decode_and_verify(params[:refresh_token])

      session = Session.find_by!(user_id: token_contents[:sub], jti: token_contents[:jti], expires_at: DateTime.now.utc..)
      user = session.user
      session.destroy!
    else
      raise ActionController::BadRequest
    end

    access_token_expires_in = 15.minutes
    refresh_token_id = SecureRandom.hex(32)
    refresh_token_expiry = DateTime.now.utc + 14.days

    access_token = jwt_encode(
      jti: SecureRandom.hex(32),
      exp: (DateTime.now.utc + access_token_expires_in).to_i,
      sub: user.id,
    )

    refresh_token = jwt_encode(
      jti: refresh_token_id,
      exp: refresh_token_expiry.to_i,
      sub: user.id,
    )

    Session.new(
      user: user,
      jti: refresh_token_id,
      expires_at: refresh_token_expiry,
    ).save!

    render json: {
      access_token: access_token,
      refresh_token: refresh_token,
      token_type: 'bearer',
      expires_in: access_token_expires_in.to_i
    }
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    raise ActionController::BadRequest
  end

  def destroy
    raise ActionController::BadRequest unless params.has_key?(:token)

    token_contents = jwt_decode_and_verify(params[:token])

    Session.destroy_by(jti: token_contents[:jti])
  rescue JWT::DecodeError
    raise ActionController::BadRequest
  end

  private
    def saml_settings
      Rails.cache.fetch(SAML_SETTINGS_CACHE_KEY, expires_in: SAML_SETTINGS_CACHE_DURATION, skip_nil: true) do
        idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
        idp_metadata = idp_metadata_parser.parse_remote(Rails.configuration.x.saml.idp_metadata_url)

        idp_metadata.assertion_consumer_service_url = sessions_callback_url
        idp_metadata.sp_entity_id = Rails.configuration.x.saml.sp_entity_id
        idp_metadata.idp_entity_id = Rails.configuration.x.saml.idp_entity_id
        idp_metadata.idp_sso_service_url = Rails.configuration.x.saml.idp_sso_service_url

        idp_metadata
      end
    end

    def sha256(message)
      Digest::SHA2.new(256).hexdigest(message)
    end
end
