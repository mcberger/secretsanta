module EventsHelper
  # helper_method :match_giver_to_giftee, :user_participating_in_event, :event_exchanges, :event_users, :set_EventUser_column

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

    # delete the existing exchanges for the event
    exes = Exchange.where(event_id: event_id)
    exes.each do |exch|
      exch.destroy
    end

    # get the event from the id
    event = Event.find event_id
    # get the event's participating users
    users = event.users
    join = EventUser.where(event_id: event_id)
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
end
