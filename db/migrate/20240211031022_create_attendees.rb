class CreateAttendees < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :phone_number
      t.text :address
      t.string :credit_card_info
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
