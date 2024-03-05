class AddForeignKeyToTickets < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :tickets, :users
    add_foreign_key :tickets, :events
    add_foreign_key :tickets, :rooms
  end
end
