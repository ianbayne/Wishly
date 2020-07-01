class ApplicationMailer < ActionMailer::Base
  default "Message-ID": -> {
    "<#{SecureRandom.uuid}@#{ActionMailer::Base.smtp_settings[:domain]}>"
  }

  default from: 'support@wishly.com'
  layout 'mailer'
end
