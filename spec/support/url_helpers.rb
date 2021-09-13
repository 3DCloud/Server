# frozen_string_literal: true

module UrlHelpers
  def base_url
    Rails.application.routes.default_url_options[:host]
  end
end
