class ApplicationMailer < ActionMailer::Base
  default from: 'MyData Weekly Digest <weekly-digest@ownyourdata.eu>'
  layout 'mailer'
end
