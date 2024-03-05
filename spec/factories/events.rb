FactoryBot.define do
  factory :event do
    name { "MyString" }
    category { "MyString" }
    date { "2024-02-12" }
    start_time { "2024-02-12 14:25:56" }
    end_time { "2024-02-12 14:25:56" }
    ticket_price { "9.99" }
    seats_left { 100 }
  end
end
