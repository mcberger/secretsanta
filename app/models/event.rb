class Event < ActiveRecord::Base
	
	has_many :users, through: :event_users
	has_many :event_users
	has_many :exchanges

end
