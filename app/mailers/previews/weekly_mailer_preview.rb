class WeeklyMailerPreview < ActionMailer::Preview
    def send_email()
        WeeklyMailer.send_email(Subscription.first.email)
    end
end
