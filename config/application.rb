# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Server
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.action_mailer.smtp_settings = Rails.application.secrets.smtp

    # SAML SP configuration
    config.x.saml.sp_entity_id = 'print.makerepo.com'
    config.x.saml.idp_entity_id = 'https://makerepo.com/saml/auth'
    config.x.saml.idp_metadata_url = 'https://makerepo.com/saml/metadata.xml'
    config.x.saml.idp_sso_service_url = 'https://makerepo.com/saml/auth'

    # JWT
    config.x.jwt.issuer = "3dcloud-#{Rails.env}"
    config.x.jwt.algorithm = 'ED25519'
    config.x.jwt.encode_key = RbNaCl::Signatures::Ed25519::SigningKey.new(Rails.application.secrets.dig(:jwt_secret) || SecureRandom.hex(16))
    config.x.jwt.decode_key = config.x.jwt.encode_key.verify_key

    config.autoload_paths << Rails.root.join('lib')

    config.x.frontend_base_url = 'http://localhost:4200'

    if (host = ENV['REDIS_HOST'] || Rails.application.secrets.dig(:redis_host)).present? &&
       (port = ENV['REDIS_PORT'] || Rails.application.secrets.dig(:redis_port)).present?
      config.x.redis = {
        host: host,
        port: port,
        password: Rails.application.secrets.dig(:redis_password)
      }
    else
      config.x.redis = {
        path: Rails.application.secrets['redis_socket_path']
      }
    end
  end
end
