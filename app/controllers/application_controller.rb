# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JwtHelper

  BadRequest = ActionController::BadRequest

  class Unauthorized < ActionController::ActionControllerError
    def initialize
      super('Missing credentials')
    end
  end

  class Forbidden < ActionController::ActionControllerError
    def initialize
      super('You are not allowed to access this page.')
    end
  end

  before_action :verify_access_token

  rescue_from BadRequest, with: :handle_bad_request
  rescue_from Unauthorized, with: :handle_unauthorized
  rescue_from Forbidden, with: :handle_forbidden
  rescue_from JWT::DecodeError, with: :handle_jwt_decode_error

  def current_user
    @current_user ||= User.find(@jwt[:sub])
  end

  private
    def verify_access_token
      raise Unauthorized unless request.headers['Authorization'] && request.headers['Authorization'].start_with?('Bearer ')

      token = request.headers['Authorization'][7..]
      @jwt = jwt_decode_and_verify(token)
    end

    # @param err [ActionController::BadRequest]
    def handle_bad_request(err)
      render_error(err.class.name, err.message, 400)
    end

    # @param err [Unauthorized]
    def handle_unauthorized(err)
      render_error(err.class.name, err.message, 401)
    end

    # @param err [Forbidden]
    def handle_forbidden(err)
      render_error(err.class.name, err.message, 403)
    end

    # @param err [JWT::DecodeError]
    def handle_jwt_decode_error(err)
      render_error(err.class.name, err.message, 401)
    end

    def render_error(name, message, status = 500)
      render plain: message, json: { error: name, message: message }, status: status
    end
end
