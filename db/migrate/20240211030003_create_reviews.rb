class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :attendee_id
      t.integer :event_id
      t.integer :rating
      t.text :feedback

      t.timestamps
    end
  end
end
