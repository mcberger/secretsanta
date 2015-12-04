class UserMailer < ApplicationMailer
	default from: 'gifter.hohoho@gmail.com'

	def welcome_email(user)
		@user = user
		@url = 'http://localhost:3000/users/sign_in'
		mail(to: @user.email, subject: 'Welcome to Gifter!')
	end

	def new_event(event, user)
		@event = event
		@user = user
		@url = "http://localhost:3000/events/#{@event.id}"
		mail(to: @user.email, subject: 'New event created!')
	end

	def gift_assigned(event, users)
		@event = event
		@users = users
		@url = "http://localhost:3000/users/#{@ .id}"
		users.each do |user|
			mail(to: user.email, subject: 'Giftees assigned!')
		end
	end
end
