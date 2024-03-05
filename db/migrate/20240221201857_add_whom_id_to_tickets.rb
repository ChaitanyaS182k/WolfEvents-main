class AddWhomIdToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :whom_id, :integer, default: nil
    change_column_default :tickets, :whom_id, from: nil, to: -> { 'user_id' }
  end
end
