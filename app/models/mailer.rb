# deprecated in rails 3.0
class Mailer < ActionMailer::Base
  def recovery(options)
    from "info@dedicatedmaps.com"
    recipients options[:email]
    subject "Dedicated Maps Account Recovery"
    content_type 'text/html'
    body :domain => options[:domain], :key => options[:key]
  end
  
  def signup(options)
    from "info@dedicatedmaps.com"
    recipients options[:email]
    subject "Your Dedicated Maps Account"
    content_type 'text/html'
    body :password => options[:password], :username => options[:username], :domain => options[:domain]
  end
end