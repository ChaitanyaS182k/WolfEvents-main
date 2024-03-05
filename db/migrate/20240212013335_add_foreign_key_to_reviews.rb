class AddForeignKeyToReviews < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :reviews, :users
    add_foreign_key :reviews, :events

  end
end
