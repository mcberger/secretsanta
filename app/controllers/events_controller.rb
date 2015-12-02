class EventsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @user = current_user
    if @event.save 
      current_user.events << @event
      UserMailer.new_event(@event, @user).deliver_later
      flash[:notice] = "Your event was created."
      redirect_to event_path @event
    else 
      flash[:alert] = "There was a problem creating your event."
      render "new"
    end
  end

  def edit
    @event = Event.find params[:id]
  end

  def update
  end

  def destroy
  end


  private
  def event_params
    params.require(:event).permit(:name, :date, :location, :deadline, :max_price, :min_price)
  end
end
