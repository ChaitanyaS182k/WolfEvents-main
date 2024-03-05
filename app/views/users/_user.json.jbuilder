json.extract! user, :id, :email, :password_digest, :name, :phone_number, :address, :credit_card_info, :admin, :created_at, :updated_at
json.url user_url(user, format: :json)
