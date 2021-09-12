# frozen_string_literal: true

require 'omniauth'

OmniAuth.configure do |config|
  config.request_validation_phase = false
end

Rails.application.config.middleware.use OmniAuth::Builder do
  idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
  idp_metadata = idp_metadata_parser.parse_remote_to_hash(ENV['IDP_METADATA_URL'])

  provider :saml,
    idp_metadata.merge(
      issuer: 'print.makerepo.com',
      idp_entity_id: 'https://makerepo.com/saml/auth',
      idp_sso_service_url: 'https://makerepo.com/saml/auth',
      name_identifier_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent',
      attribute_statements: {
        name: %w(name),
        email: %w(email_address),
        nickname: %w(username),
      }
    )
end
