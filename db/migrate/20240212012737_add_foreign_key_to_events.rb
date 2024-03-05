class AddForeignKeyToEvents < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :events, :rooms
  end
end
