FactoryBot.define do
  factory :ticket do
    user
    event
    quantity { 1 }
    # Add other necessary ticket attributes
  end
end