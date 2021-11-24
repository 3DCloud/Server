# frozen_string_literal: true

class WebSocketTicket < ApplicationRecord
  belongs_to :user, optional: true

  validates :ticket, presence: true
  validates :expires_at, presence: true
end
