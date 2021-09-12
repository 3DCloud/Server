# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true
  validates :name, presence: true
  validates :email_address, presence: true
  validates :sso_uid, presence: true, uniqueness: true

  class << self
    # @param response [OneLogin::RubySaml::Response]
    def get_or_create_from_saml_response(response)
      uid = response.name_id

      user = User.find_by(sso_uid: uid) || User.new(sso_uid: uid)

      user.username = response.attributes[:username]
      user.name = response.attributes[:name]
      user.email_address = response.attributes[:email_address]
      user.save!

      user
    end
  end
end
