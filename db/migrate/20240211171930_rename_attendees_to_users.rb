class RenameAttendeesToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_table :attendees, :users
  end
end
