# frozen_string_literal: true

module JwtHelper
  def jwt_encode(**payload)
    JWT.encode({
      **payload,
      iss: jwt_issuer,
    }, jwt_encode_key, jwt_algorithm)
  end

  def jwt_decode_and_verify(token)
    JWT.decode(token, jwt_decode_key, true, {
      algorithm: jwt_algorithm,
      iss: jwt_issuer,
      verify_iss: true,
    }).first.symbolize_keys
  end

  private
    def jwt_issuer
      Rails.configuration.x.jwt.issuer
    end

    def jwt_algorithm
      Rails.configuration.x.jwt.algorithm
    end

    def jwt_encode_key
      Rails.configuration.x.jwt.encode_key
    end

    def jwt_decode_key
      Rails.configuration.x.jwt.decode_key
    end
end
