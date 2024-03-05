module RoomsHelper
  def free_rooms(requested_start_time,requested_end_time,requested_date,seats_left)
      rooms=Room.where.not(
        id:Event.where(
          '(? >= start_time AND ? < end_time) OR (? > start_time AND ? <= end_time) OR (? <= start_time AND ? >= end_time)', requested_start_time, requested_start_time, requested_end_time, requested_end_time, requested_start_time, requested_end_time)
                .and(Event.where(date:requested_date)).pluck(:room_id)

    ).and(Room.where("capacity >= ?", seats_left))
    return rooms
  end

  def check_event_update_is_valid(event,id)
    requested_date = Date.parse(event[:date].to_s)
    requested_start_time = (Date.new(2000, 01 ,01)+ Time.parse(event[:start_time].to_s).seconds_since_midnight.seconds).to_datetime
    requested_end_time = (Date.new(2000, 01 ,01)+ Time.parse(event[:end_time].to_s).seconds_since_midnight.seconds).to_datetime
    room=Room.find(event[:room_id])
    seatsCheck=room.capacity>event[:seats_left].to_i
    room_clashed_events=Event.where(
      '(? >= start_time AND ? < end_time) OR (? > start_time AND ? <= end_time) OR (? <= start_time AND ? >= end_time)', requested_start_time, requested_start_time, requested_end_time, requested_end_time, requested_start_time, requested_end_time)
                             .and(Event.where(date:requested_date)).and(Event.where(room_id:room.id))
    if room_clashed_events.length()>2
      roomFree=false
    elsif room_clashed_events.length()==1

      roomFree=room_clashed_events[0].id==id.to_i   #check if the clashed event is the event which admin is updating
    else
      roomFree=true
    end
    return roomFree && seatsCheck
  end


end
