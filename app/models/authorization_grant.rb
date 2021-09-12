# frozen_string_literal: true

class AuthorizationGrant < ApplicationRecord
  belongs_to :user

  validates :authorization_code, presence: true, uniqueness: { scope: :code_challenge }
  validates :code_challenge, presence: true, uniqueness: { scope: :authorization_code }
  validates :expires_at, presence: true
end
