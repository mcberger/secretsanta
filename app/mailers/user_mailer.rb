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
end
