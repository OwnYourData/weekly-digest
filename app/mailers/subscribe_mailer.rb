class SubscribeMailer < ApplicationMailer
    include ApplicationHelper
    layout 'mailer_plain'

    def send_email(to, key, lang)
        @email = to
        @key = key
        @lang = lang || "en"

        mail(to: to, subject: "MyData Weekly Digest: Confirm your subscription")
    end
end
