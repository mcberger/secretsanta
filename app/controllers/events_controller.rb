class EventsController < ApplicationController
  def index
    @events = Event.all

  end

  def show
    @event = Event.find(params[:id])
    join = EventUser.where(event_id: @event.id, admin: true).last
    user = User.where(id: join.user_id).last
    @host = user.email 
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @user = current_user
    if @event.save 
      current_user.events << @event
      EventUser.last.update admin: true
      UserMailer.new_event(@event, @user).deliver_later
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
