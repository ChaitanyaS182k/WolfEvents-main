class ExtraController < ApplicationController
  def index
    if !current_user.admin
      redirect_to home_url
    end
    @events=(Event.all).pluck(:name)
    if params[:event_name].present?
      @attendees=User.where(id:Ticket.all.joins(:event).where(event:{name:params[:event_name]}).pluck(:user_id))
    else
      @attendees=[]
  end
  end
  end