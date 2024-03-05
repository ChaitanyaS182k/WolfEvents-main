# app/helpers/tickets_helper.rb
module TicketsHelper
  def filter_tickets(tickets, category, price_min, price_max, event_name)
    filtered_tickets = tickets

    if category.present?
      filtered_tickets = filtered_tickets.select { |ticket| ticket.event.category == category }
    end

    if price_min.present?
      filtered_tickets = filtered_tickets.select { |ticket| ticket.event.ticket_price >= price_min.to_i }
    end

    if price_max.present?
      filtered_tickets = filtered_tickets.select { |ticket| ticket.event.ticket_price <= price_max.to_i }
    end

    if event_name.present?
      filtered_tickets = filtered_tickets.select { |ticket| ticket.event.name.include?(event_name) }
    end
    return filtered_tickets
  end

  def script_to_book_dummy_tickets_for_new_user_for_passed_events(user_id)
    today_time=(Date.new(2000, 01 ,01)+ Time.now.seconds_since_midnight.seconds).to_datetime
    today_date=Date.today
    passed_events=events=Event.where("(date < ? ) OR (date=? AND end_time < ?)", today_date,today_date,today_time).and(Event.where("seats_left > ?",0))
    passed_events.each do |event|
      ticket=Ticket.new
      ticket.user_id=user_id
      ticket.whom_id=user_id
      ticket.room_id=event.room_id
      ticket.event_id=event.id
      ticket.quantity=1
      ticket.confirmation_number=Array.new(10){[*"A".."Z", *"0".."9"].sample}.join
      ticket.save
    end
  end
end
