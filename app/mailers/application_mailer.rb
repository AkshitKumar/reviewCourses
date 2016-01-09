class ApplicationMailer < ActionMailer::Base
  default from: "username@gmail.com"
  layout 'mailer'
end
