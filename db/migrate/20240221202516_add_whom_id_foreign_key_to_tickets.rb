class AddWhomIdForeignKeyToTickets < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :tickets, :users, column: :whom_id, default: -> { 'user_id' }
  end
end
