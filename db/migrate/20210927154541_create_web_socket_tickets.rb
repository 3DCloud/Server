class CreateWebSocketTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :web_socket_tickets do |t|
      t.references :user, foreign_key: true, null: false
      t.string :ticket, null: false
      t.datetime :expires_at
      t.timestamps

      t.index :ticket, unique: true
    end
  end
end
