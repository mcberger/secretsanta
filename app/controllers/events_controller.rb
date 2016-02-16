class EventsController < ApplicationController

  def index
    @events = Event.all
    @title = 'All events'
  end

  def show
    @event = Event.find(params[:id])
    join = EventUser.where(event_id: @event.id, admin: true).last
    user = User.find join.user_id
    @host = user.email 
    @users = @event.users
    allUsers = User.all
    @allOptOutUsers = []

    # if a user is participating in the event
    # exclude any users from the list of system users
    # so they can't be readded to the event
    dontadd = []
    @users.each do |event_user|
      if user_participating_in_event(@event.id, event_user.id)
        dontadd << event_user
      end
    end

    # remove participating users from @allOptOutsers
    allUsers.each do |system_user|
      if !dontadd.include?(system_user)
        @allOptOutUsers << system_user
      end
    end
    #User.Mailer.gift_assigned(@event, @users).deliver_later
    @title = @event.name
  end

  def new
    @event = Event.new
    @title = 'New event'
  end

  def create
    @event = Event.new(event_params)
    @user = current_user
    if @event.save 
      #
      # User has created an event so is now designated an admin. Set 
      # the admin & participation field to 'true' on the EventUser table.
      #
      current_user.events << @event
      EventUser.last.update admin: true, participation: true
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
    @title = 'Edit event'
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
  @event = Event.find(params[:id])
  if @event.destroy
    flash[:notice] = "The event was deleted successfully."
    redirect_to events_path
  else
    flash[:alert] = "There was a problem deleting the event."
    redirect_to @event
  end
end

def add_existing_users
  flash[:notice] = "Users have been added to the event successfully."

  event = Event.find params[:id]
  params[:user_ids].each do |user_id|
    user = User.find user_id
    user.events << event
      # check the user's record in the EventUsers join table,
      # set the participation bit
      EventUser.last.update participation: true
    end
    redirect_to event_path params[:id]
  end

  def add_new_users
    @event = Event.find(params[:id])
    users = params[:email].gsub(/\s+/,"")
    emails = users.split(",")
    flash[:notice] = ""
    flash[:alert]=""
    #creating new users taking the emails from above
    emails.each do |email|
      @user = User.create email: email, password: "12345678"
      if @user
        @user.events << @event
        flash[:notice] += "Users #{email} created successfully."
        #UserMailer.welcome_email_alt(@event, @user).deliver_later
      else
       flash[:alert] += "Failed to create user #{email}."
     end 
   end
   redirect_to event_path @event
 end

private
def event_params
  params.require(:event).permit(:name, :date, :location, :deadline, :max_price, :min_price)
end

include EventsHelper
end
