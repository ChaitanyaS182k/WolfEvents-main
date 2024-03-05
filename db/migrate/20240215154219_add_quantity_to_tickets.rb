class AddQuantityToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :quantity, :integer
    safety_assured { execute "ALTER TABLE tickets ADD CONSTRAINT non_negative_quantity CHECK (quantity >= 0);" }
  end
end
