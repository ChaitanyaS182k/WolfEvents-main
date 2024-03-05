# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'bcrypt'

User.destroy_all

hashed_password = BCrypt::Password.create("wolfEvents@123")

user = User.create(
  email: "wolf_admin@ncsu.edu",
  password: hashed_password,
  name: "Mr. Wuf",
  phone_number: "9195152011",
  address: "Campus Box 7103. NC State University Raleigh, NC 27695-7103",
  credit_card_info: "4716-3333-5947-3206",
  admin: true,
  created_at: 1.week.ago,
  updated_at: 1.week.ago
)

if user.valid?
  p "User created successfully"
else
  p "User creation failed with errors: #{user.errors.full_messages}"
end

p "Created #{User.count} users"
