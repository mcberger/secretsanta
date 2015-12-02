class EventsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @event = Event.new
    @user = User.find_by_id(params[:user_id])
  end

  def create
    @user = User.find_by_id(params[:user_id])
    @event = Event.new(event_params)
    if @event.save
      @user.events << @event
      UserMailer.new_event(@user).deliver_later
      flash[:notice] = "Your event was created."
      redirect_to event_path @event
    else 
      flash[:alert] = "There was a problem creating your event."
      render "new"
    end
  end

  def edit
  end

  def destroy
  end


  private
  def event_params
    params.require(:event).permit(:name, :date, :location, :deadline, :max_price, :min_price)
  end
end
