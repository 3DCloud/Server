# frozen_string_literal: true

class AllowNullUserOnWebSocketTicket < ActiveRecord::Migration[6.1]
  def change
    change_column_null :web_socket_tickets, :user_id, true
  end
end
