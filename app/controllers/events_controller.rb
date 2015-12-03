class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    join = EventUser.where(event_id: @event.id, admin: true).last
    user = User.find join.user_id
    @host = user.email 
    @users = @event.users
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @user = current_user
    if @event.save 
      #
      # User has created an event so is now designated an admin.
      # Set the admin field on the EventUser table.
      #
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
    @event = Event.find params[:id]
  end

  def update
    #
    # get the current event and update it with the data supplied by the user
    #
    event = Event.find params[:id]
    if event
      event.update event_params
      flash[:notice] = "Your event was modified successfully."
    else
       flash[:alert] = "There was a problem editing your event."
    end     
    redirect_to event_path params[:id]
  end

  def destroy
  end


  private
  def event_params
    params.require(:event).permit(:name, :date, :location, :deadline, :max_price, :min_price)
  end
end
