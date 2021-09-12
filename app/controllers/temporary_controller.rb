# frozen_string_literal: true

class TemporaryController < ApplicationController
  def index
    render html: '<html><body><form method="POST" action="/auth/saml"><button type="submit">Log in</button></form></body></html>'.html_safe
  end
end
