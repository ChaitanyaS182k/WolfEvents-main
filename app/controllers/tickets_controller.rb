class TicketsController < ApplicationController
  include TicketsHelper
  before_action :set_ticket, only: %i[ show edit update destroy ]

  # GET /tickets or /tickets.json
  def index
    @category = params[:category]
    @price_min = params[:price_min]
    @price_max = params[:price_max]
    @event_name = params[:event_name]

    if current_user.admin?
      # If admin, show all tickets
      @tickets = Ticket.all
    else
      # If not admin, show only tickets purchased by the current user
      whom_tickets = Ticket.where(whom_id: current_user.id).where.not(user_id: current_user.id)

      # Also include tickets purchased by the current user
      user_tickets = current_user.tickets

      @tickets = whom_tickets + user_tickets
    end

    # Filter tickets based on the provided parameters
    @tickets = filter_tickets(@tickets, @category, @price_min, @price_max, @event_name)
  end


  # private


  # GET /tickets/1 or /tickets/1.json
  def show
    if current_user.id != @ticket.user_id && !current_user.admin
      redirect_to root_path
    end
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
    # We add these lines so that the selected evetets’s data fields are available to the views at the front end
    if @event.nil?
      begin
        @event = Event.find(params[:event_id])
      rescue
        redirect_to root_path
      end
    end
  end

  # GET /tickets/1/edit
  def edit
    if current_user.id != @ticket.user_id && !current_user.admin
      redirect_to root_path
    end

    if @event.nil?
      @event= @ticket.event
    end
  end

  # POST /tickets or /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.confirmation_number = Array.new(10){[*"A".."Z", *"0".."9"].sample}.join
    @event = Event.find(params[:ticket][:event_id])

    @ticket.whom_id = @ticket.user.id
    @ticket.user = current_user
    @ticket.room_id = @event.room_id

    respond_to do |format|
      if (@event.seats_left - @ticket.quantity) < 0
        format.html { redirect_to events_url, alert: 'Not enough seats left!!' }
        format.json { render json: { error: 'Not enough seats left' }, status: :unprocessable_entity }
      else
        if @ticket.save
          @event.seats_left -= @ticket.quantity
          @event.save
          format.html { redirect_to ticket_url(@ticket), notice: 'Ticket was successfully created and booked.' }
          format.json { render :show, status: :created, location: @ticket }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /tickets/1 or /tickets/1.json
  def update
    @event = @ticket.event
    prev_quantity = @ticket.quantity

    respond_to do |format|
      if @ticket.update(ticket_params)
        new_quantity = @ticket.quantity
        quantity_difference = new_quantity - prev_quantity

        if @event.seats_left - quantity_difference >= 0 && new_quantity >= 0
          # Perform actions with previous quantity (prev_quantity) here if needed
          @event.seats_left -= quantity_difference
          @event.save

          format.html { redirect_to ticket_url(@ticket), notice: "Ticket was successfully updated." }
          format.json { render :show, status: :ok, location: @ticket }
        else
          # If not enough seats left or new quantity is negative
          format.html { redirect_to events_url, alert: 'Not enough seats left!!' }
          format.json { render json: { error: 'Not enough seats left' }, status: :unprocessable_entity }
        end
      else
        # Handle update errors
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /tickets/1 or /tickets/1.json
  def destroy
    @ticket.destroy
    @event = @ticket.event

    respond_to do |format|
      @event.seats_left = @event.seats_left + @ticket.quantity
      @event.save

      format.html { redirect_to tickets_url, notice: "Ticket was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def ticket_params
      params.require(:ticket).permit(:user_id, :event_id, :quantity, :whom)
  end
end
