# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true
  validates :name, presence: true
  validates :email_address, presence: true
  validates :sso_uid, presence: true, uniqueness: true

  has_many :uploaded_files

  class << self
    # @param uid [String]
    # @param attributes [OneLogin::RubySaml::Attributes]
    def get_or_create_from_saml_response(uid, attributes)
      user = User.find_by(sso_uid: uid) || User.new(sso_uid: uid)

      user.username = attributes[:username]
      user.name = attributes[:name]
      user.email_address = attributes[:email_address]
      user.save!

      user
    end
  end
end
