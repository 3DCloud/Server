# frozen_string_literal: true

require 'omniauth'

OmniAuth.configure do |config|
  config.request_validation_phase = false
end

Rails.application.config.middleware.use OmniAuth::Builder do
  idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
  idp_metadata = idp_metadata_parser.parse_remote_to_hash(Rails.application.secrets.dig(:saml, :idp_metadata_url))

  provider :saml,
    idp_metadata.merge(
      issuer: Rails.application.secrets.dig(:saml, :issuer),
      idp_entity_id: Rails.application.secrets.dig(:saml, :idp_entity_id),
      idp_sso_service_url: Rails.application.secrets.dig(:saml, :idp_sso_service_url),
      attribute_statements: {
        name: %w(name),
        email: %w(email_address email mail),
        nickname: %w(nickname username),
      }
    )
end
