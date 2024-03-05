class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]

  # GET /reviews or /reviews.json
  def index
    if current_user.admin
      @reviews=Review.all
    elsif params[:user_id].present?
      if params[:user_id].to_i==current_user.id
        @reviews=Review.where(user_id:current_user.id.to_i) # filter all reviews for current user
        logger.info @reviews
      else
        @reviews=[]
      end
    else
      @reviews=Review.joins(:event).where(event:{category:['Concerts', 'Sports', 'Arts & Theatre']}) #filter all reviews for only 3 categories
    end
  end


  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    review_event=params[:event_id]
    @event=Event.find(review_event)
    @reviewer=current_user.id
    @review=Review.new
    today_time=(Date.new(2000, 01 ,01)+ Time.now.seconds_since_midnight.seconds).to_datetime
    today_date=Date.today
    @cannot_review=false
    if !(@event.end_time<today_time && @event.date<=today_date)   #check if user can create a review for event_id before its finished
      @cannot_review=true
    end
  end

  # GET /reviews/1/edit
  def edit
    review=Review.find(params[:id])
    @event=Event.find(review.event_id)
    @reviewer=review.user_id
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)
    user_event_check=(Ticket.where(event_id:@review.event_id).and(Ticket.where(user_id: current_user.id))).length >0
    # check if user has attended event for which he/she is adding review

    respond_to do |format|
      if user_event_check && @review.user_id==current_user.id && @review.save
        format.html { redirect_to review_url(@review), notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @review }
      else
        @event=Event.find(@review.event_id)
        @reviewer=current_user.id
        @review.errors.add(:user_id , "User not attended Event or Cannot Add review for someone else" )
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    user_event_check=(Ticket.where(event_id:@review.event_id).and(Ticket.where(user_id: current_user.id))).length >0
    auth= current_user.admin || (user_event_check && @review.user_id==current_user.id)  # update allowed only if user is admin and if user has attended event
    respond_to do |format|
      if auth && @review.update(review_params)
        format.html { redirect_to review_url(@review), notice: "Review was successfully updated." }
        format.json { render :show, status: :ok, location: @review }
      else
        @event=Event.find(@review.event_id)
        @reviewer=current_user.id
        @review.errors.add(:user_id , "User not attended Event or Cannot Add review for someone else" )
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    user_event_check=(Ticket.where(event_id:@review.event_id).and(Ticket.where(user_id: current_user.id))).length >0
    auth= current_user.admin || (user_event_check && @review.user_id==current_user.id)  #destroy only allowed if user has attended or its an admin
    if auth
      @review.destroy!
      respond_to do |format|
        format.html { redirect_to reviews_url, notice: "Review was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:user_id, :event_id, :rating, :feedback)
    end

end
