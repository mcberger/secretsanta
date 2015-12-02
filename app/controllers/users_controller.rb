class UsersController < ApplicationController
  def new
  end

  def create
  end

  def destroy
  end

  def edit
  end

  def index
  end

  def show
    # get user and associated events
    #
    user = User.find current_user
    events = user.events
    #
    # separate user's events into pending and past
    #
    @pending_events = []
    @past_events = []
    puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    events.each do |event|
      if event.date >= Time.now
        puts "----  #{event.name}  #{event.date} is later than #{Time.now} -----"
        @pending_events << event
      else
        puts "----  #{event.name}  #{event.date} is earlier than #{Time.now} -----"
        @past_events << event
      end
    end
  end
end
