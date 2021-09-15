# frozen_string_literal: true

module JwtHelper
  def jwt_encode(**payload)
    JWT.encode(payload, jwt_secret, jwt_algorithm)
  end

  def jwt_decode(token)
    JWT.decode(token, jwt_secret, true, {
      algorithm: jwt_algorithm,
      iss: jwt_issuer,
      verify_iss: true,
    }).first.symbolize_keys
  end

  def jwt_issuer
    Rails.configuration.x.jwt.issuer
  end

  private
    def jwt_algorithm
      Rails.configuration.x.jwt.algorithm
    end

    def jwt_secret
      Rails.application.secrets.dig(:jwt_secret)
    end
end
