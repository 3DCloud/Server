# frozen_string_literal: true

class Session < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :jti, presence: true, uniqueness: true
  validates :expires_at, presence: true
end
