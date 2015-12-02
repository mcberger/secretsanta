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
    @user = current_user
    events = @user.events
    #
    # separate user's events into pending and past
    #
    @pending_events = []
    @past_events = []

    events.each do |event|
      if event.date >= Time.now
        @pending_events << event
      else
        @past_events << event
      end
    end
  end
end
