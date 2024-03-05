json.extract! ticket, :id, :User_id, :event_id, :room_id, :confirmation_number, :quantity, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
