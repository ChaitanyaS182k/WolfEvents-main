# db/migrate/[timestamp]_update_attendee_id_to_user_id.rb

class UpdateAttendeeIdToUserId < ActiveRecord::Migration[7.1]
  def change
    rename_column :reviews, :attendee_id, :user_id
    rename_column :tickets, :attendee_id, :user_id
    # Add more tables here if needed
  end
end
