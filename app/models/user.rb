# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true
  validates :name, presence: true
  validates :email_address, presence: true
  validates :sso_provider, presence: true
  validates :sso_uid, presence: true

  class << self
    def get_or_create_from_omniauth_hash(obj)
      user = User.find_by(sso_provider: obj.provider, sso_uid: obj.uid) || User.new(
        sso_provider: obj.provider,
        sso_uid: obj.uid
      )

      user.username = obj.info.nickname
      user.name = obj.info.name
      user.email_address = obj.info.email
      user.save!

      user
    end
  end
end
