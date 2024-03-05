class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :room_id
      t.string :category
      t.date :date
      t.time :start_time
      t.time :end_time
      t.decimal :ticket_price
      t.integer :seats_left

      t.timestamps
    end
  end
end
