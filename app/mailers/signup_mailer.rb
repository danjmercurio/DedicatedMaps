class SignupMailer < ActionMailer::Base
  default from: "no-reply@dedicated.com"

  def signupMail(user, pword)
    @domain = "dedicatedmaps.com"
  	@user = user
    @pword = pword
  	mail(:to => @user.email,
  		:subject => "Welcome to Dedicated Maps!",
  		:email => @user.email,
        :password => @pword,
        :username => @user.username,
        )
  end
end
