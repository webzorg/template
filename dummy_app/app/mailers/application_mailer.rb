class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials[:from_email]
  layout "mailer"
end
