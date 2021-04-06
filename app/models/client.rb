# frozen_string_literal: true

class Client < ApplicationRecord
  include BCrypt

  has_many :devices

  def secret
    @secret ||= Password.new(secret_digest)
  end

  def secret=(new_secret)
    @secret = Password.create(new_secret)
    self.secret_digest = @secret
  end
end
