class WebSocketTicket < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :ticket, presence: true
end