# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar, service: "#{Rails.configuration.active_storage.service}_public".to_sym
  validates :username, presence: true
  validates :name, presence: true
  validates :email_address, presence: true
  validates :sso_uid, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: %w(admin staff volunteer regular_user)

  has_many :uploaded_files

  class << self
    # @param uid [String]
    # @param attributes [OneLogin::RubySaml::Attributes]
    def get_or_create_from_saml_response(uid, attributes)
      user = User.find_by(sso_uid: uid) || User.new(sso_uid: uid)

      if attributes[:avatar_transient_url] && attributes[:avatar_content_type]
        user.avatar.attach(
          io: URI.open(attributes[:avatar_transient_url]),
          filename: "#{attributes[:username]}_avatar",
          content_type: attributes[:avatar_content_type]
        )
      end

      user.username = attributes[:username]
      user.name = attributes[:name]
      user.email_address = attributes[:email_address]
      user.role = attributes[:role]
      user.save!

      user
    end
  end

  def admin?
    role == 'admin'
  end

  def staff?
    %w(admin staff).include?(role)
  end

  def volunteer?
    %w(admin staff volunteer).include?(role)
  end
end
