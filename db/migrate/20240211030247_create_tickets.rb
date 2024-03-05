class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.integer :attendee_id
      t.integer :event_id
      t.integer :room_id
      t.string :confirmation_number

      t.timestamps
    end
  end
end
