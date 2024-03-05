class EventsController < ApplicationController
  include RoomsHelper
  before_action :set_event, only: %i[ show edit update destroy ]
  helper_method :verify_user_can_purchase

  # GET /events or /events.json
  def index
    if current_user.admin?
      @category = params[:category]
      @price_min = params[:price_min]
      @price_max = params[:price_max]
      @event_name = params[:event_name]
      @date = params[:date]

      @events = Event.all
      # Query your events based on the provided parameters
      #logic to filter events using ticket price category and event name
      @events = @events.where(category: @category) if @category.present?
      @events = @events.where('ticket_price >= ?', @price_min) if @price_min.present?
      @events = @events.where('ticket_price <= ?', @price_max) if @price_max.present?
      @events = @events.where('name LIKE ?', "%#{@event_name}%") if @event_name.present?
      @events = @events.where('date LIKE ?', "%#{@date}%") if @date.present?
    else
      #logic to filter upcoming events
      today_time=(Date.new(2000, 01 ,01)+ Time.now.seconds_since_midnight.seconds).to_datetime
      today_date=Date.today
      @events=Event.where("(date > ? ) OR (date=? AND end_time > ?)", today_date,today_date,today_time).and(Event.where("seats_left > 0"))
      @category = params[:category]
      @price_min = params[:price_min]
      @price_max = params[:price_max]
      @event_name = params[:event_name]
      @date = params[:date]

      #logic to filter events using ticket price category and event name
      @events = @events.where(category: @category) if @category.present?
      @events = @events.where('ticket_price >= ?', @price_min) if @price_min.present?
      @events = @events.where('ticket_price <= ?', @price_max) if @price_max.present?
      @events = @events.where('name LIKE ?', "%#{@event_name}%") if @event_name.present?
      @events = @events.where('date LIKE ?', "%#{@date}%") if @date.present?

    end
  end


  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @categories= ['Concerts', 'Sports', 'Arts & Theatre', 'Miscellaneous/Family – Private']
  end

  # GET /events/1/edit
  def edit
    event=Event.find(params[:id])
    @room=Room.find(event.room_id)
  end

  # POST /events or /events.json
  def create
    isFree=false
    @event = Event.new(event_params)
    if @event.room_id.present?
      requested_date = Date.parse(@event.date.to_s)
      requested_start_time = (Date.new(2000, 01 ,01)+ Time.parse(@event.start_time.to_s).seconds_since_midnight.seconds).to_datetime
      requested_end_time = (Date.new(2000, 01 ,01)+ Time.parse(@event.end_time.to_s).seconds_since_midnight.seconds).to_datetime
      free_rooms=free_rooms(requested_start_time,requested_end_time,requested_date,@event.seats_left)
      isFree=free_rooms.any? { |room| room.id==@event.room_id}

    end
    respond_to do |format|
      if current_user.admin && isFree && @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        if !isFree
          @event.errors.add(:room_id , "Should be present and valid")
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    isFree=false
    if event_params[:room_id].present?
      requested_date = Date.parse(@event.date.to_s)
      requested_start_time = (Date.new(2000, 01 ,01)+ Time.parse(@event.start_time.to_s).seconds_since_midnight.seconds).to_datetime
      requested_end_time = (Date.new(2000, 01 ,01)+ Time.parse(@event.end_time.to_s).seconds_since_midnight.seconds).to_datetime
      free_rooms=free_rooms(requested_start_time,requested_end_time,requested_date,@event.seats_left)
      isFree=free_rooms.any? { |room| room.id==@event.room_id}
      if !isFree
        if check_event_update_is_valid(event_params,params[:id])
          isFree=true
        end
      end

    end
    respond_to do |format|
      if current_user.admin && isFree && @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        if !isFree
          @event.errors.add(:room_id , "Should be present and valid")
        end
        @room=Room.find(@event.room_id)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    if current_user.admin
      @event.destroy!
    end

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :room_id, :category, :date, :start_time, :end_time, :ticket_price, :seats_left)
    end

  def verify_user_can_purchase(event)
    today_time=(Date.new(2000, 01 ,01)+ Time.now.seconds_since_midnight.seconds).to_datetime
    today_date=Date.today
    if event.date>today_date || (event.date==today_date && event.end_time>today_time)
      return true
    else
      return false
    end
  end
end
