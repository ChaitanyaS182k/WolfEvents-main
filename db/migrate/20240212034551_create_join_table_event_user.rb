class CreateJoinTableEventUser < ActiveRecord::Migration[7.1]
  def change
    create_join_table :events, :users do |t|
      # Any additional columns for the join table can be defined here
      # For example:
      # t.boolean :attended, default: false
      t.index [:event_id, :user_id]
      # Add an index for faster querying
    end
  end
end
