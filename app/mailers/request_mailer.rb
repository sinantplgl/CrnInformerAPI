class RequestMailer < ApplicationMailer
    default from: 'Informer <crnalert@gmail.com>'
	default reply_to: "Informer <crnalert@gmail.com>"

	def inform_mail
		@user = params[:user]
		@crn = params[:crn]

		mail(to: "#{@user.email}@sabanciuniv.edu", subject: 'New available space at your tracked CRN...')
	end
end
