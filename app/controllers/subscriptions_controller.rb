class SubscriptionsController < ApplicationController
    def create
        email_str = params[:email].to_s.strip
        if email_str =~ URI::MailTo::EMAIL_REGEXP
            @subscription = Subscription.find_by_email(email_str)
            if @subscription.nil?
                @subscription = Subscription.new(email: email_str, lang: params[:locale].to_s, key: SecureRandom.base64(8), confirmed: false)
                @subscription.save
            end
            SubscribeMailer.send_email(email_str, @subscription.key, params[:locale].to_s).deliver_now            
            flash[:success] = "You should have received a confirmation email. Please check your inbox!"
        else
            flash[:warning] = "Invalid email address!"
        end
        redirect_to weekly_path(id: params[:id])
    end

    def confirm
        @subscription = Subscription.find_by_key(params[:key].to_s.gsub(" ","+"))
        if @subscription.nil?
            flash[:warning] = "Unknown subscription. No changes were made!"
        else
            @subscription.update_attributes(confirmed: true, key: SecureRandom.base64(8))
            flash[:success] = "You have successfully subscribed the MyData Weekly Digest"
        end
        redirect_to root_path
    end

    def unsubscribe
        @heading = t('general.title')
        @heading_short = t('general.title_short')

        @text = "Error: Invalid parameters!"
        @subscription = Subscription.find_by_email(params[:email].to_s)
        if !@subscription.nil?
            if @subscription.key == params[:key].to_s
                @subscription.destroy
                @text = "The email address '" + params[:email].to_s + "' was successfully unsubscribed from the Weekly Digest Newsletter."
            end
        end
        respond_to do |format|
            format.html { render layout: "application3" }
        end

    end
end
