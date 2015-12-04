class EventsController < ApplicationController

  helper_method :match_giver_to_giftee, :user_participating_in_event, :event_exchanges, :event_users, :set_EventUser_column

  # Set User user_id's participation or admin to value for 
  # Event event_id as determined by column
  def set_EventUser_column(event_id, user_id, value, column="admin")

  end

  # return a list of an event's users; participating by default,
  # but if value equals false, return non-participating
  def event_users(event_id, value=true)

  end

  # return all exchanges for an event
  # 
  def event_exchanges(event_id)
    return Exchange.where(event_id: event_id)
  end

  # return true if user is participating in event
  # 
  def user_participating_in_event(event_id, user_id)
    retval = false
    event = Event.find event_id
    join = EventUser.where(event_id: event_id, user_id: user_id).last
    if join
      retval = join.participation
    end
    return retval
  end

  def match_giver_to_giftee(event_id)
    # get the event from the id
    event = Event.find event_id
    # get the event's participating users
    users = event.users
    join = EventUser.where(event_id: @event.id)
    optin_users = []
    index = -1

    users.each do |euser|
      # check the user's record in the EventUsers join table
      if join.any?{|a| a.user_id == euser.id}
        index = join.find_index {|item| item.user_id == euser.id}
        if join[index].participation
          optin_users << euser
        end
      end
    end
    # shuffle the participating user array
    optin_users.shuffle
    # go through the shuffled array and assign n to n+1 and
    # tail to head of the list, and add them to the event
    #
    count = optin_users.length
    if (count > 1)
      for i in 0..count-2 do
        # puts "gifter: #{optin_users[i].email} giftee: #{optin_users[i+1].email} ---------------------------"
        event.exchanges << Exchange.new(gifter: optin_users[i].id, giftee: optin_users[i+1].id, event_id: event_id)
      end
      # puts "gifter: #{optin_users.last.email} giftee: #{optin_users[0].email} ---------------------------"
      event.exchanges << Exchange.new(gifter: optin_users.last.id, giftee: optin_users[0].id, event_id: event_id)
    else
      flash[:alert] = "#{optin_users[0].username} is currently the only participator in this gift exchange." if count == 1
    end
  end

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
  end

  def add_existing_users
    flash[:notice] = "Route was invoked successfully."

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

  private
  def event_params
    params.require(:event).permit(:name, :date, :location, :deadline, :max_price, :min_price)
  end
end
