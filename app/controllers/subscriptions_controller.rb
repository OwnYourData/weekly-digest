class SubscriptionsController < ApplicationController
    def create
        email_str = params[:email].to_s.strip
        puts "Email: " + email_str.to_s
        if email_str =~ URI::MailTo::EMAIL_REGEXP
            @subscription = Subscription.find_by_email(email_str)
            if @subscription.nil?
                @subscription = Subscription.new(email: email_str, lang: params[:locale].to_s, key: SecureRandom.base64(8), confirmed: false)
                @subscription.save
            end
            begin
                SubscribeMailer.send_email(email_str, @subscription.key, params[:locale].to_s).deliver_now
            rescue
                flash[:warning] = t('subscribe.invalid_email')
                if params[:id].to_s == ""
                    redirect_to subscribe_path
                    return
                end
            end
            flash[:success] = t('subscribe.success_flash')
        else
            flash[:warning] = t('subscribe.invalid_email')
            if params[:id].to_s == ""
                redirect_to subscribe_path
                return
            end
        end
        if params[:id].to_s == ""
            redirect_to root_path
        else
            redirect_to weekly_path(id: params[:id])
        end
    end

    def subscription
        if params[:key].to_s != ""
            @subscription = Subscription.find_by_key(params[:key].to_s.gsub(" ","+"))
            if @subscription.nil?
                flash[:warning] = t('subscribe.unknown')
            else
                @subscription.update_attributes(confirmed: true, key: SecureRandom.base64(8))
                flash[:success] = t('subscribe.success')
            end
            redirect_to root_path
            return
        end
        @heading = t('general.title')
        @heading_short = t('general.title_short')
        respond_to do |format|
            format.html { render layout: "application3" }
        end

    end

    def unsubscribe
        @heading = t('general.title')
        @heading_short = t('general.title_short')

        @text = "Error: Invalid parameters!"
        @subscription = Subscription.find_by_email(params[:email].to_s)
        if !@subscription.nil?
            if @subscription.key == params[:key].to_s
                @subscription.destroy
                @text = t('subscribe.unsubscribed', email: params[:email].to_s)
            end
        end
        respond_to do |format|
            format.html { render layout: "application3" }
        end

    end
end
