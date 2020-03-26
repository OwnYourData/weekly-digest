class StaticPagesController < ApplicationController
	include ApplicationHelper
	def home
		@heading = t('general.title')
		@heading_short = "Weekly Digests"
		if params[:mode].to_s == ""
			@week = Weekly.where(status: 1)
			@user = User.where(status: 1)
			@app = App.where(status: 1)
			@source = Source.where(status: 1)
		else
			@week = Weekly.all
			@user = User.all
			@app = App.all
			@source = Source.all
		end

        Statistic.new(
            timestamp: DateTime.now.to_i,
            url: request.headers["HTTP_REFERER"].to_s,
            source: "home",
            source_id: "",
            target: "",
            target_id: nil,
            session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
        ).save


        case params[:view].to_s
        when "0"
        when "2"
            respond_to do |format|
                format.html { render layout: "application2", template: "static_pages/home2"}
            end
        when "3"
            respond_to do |format|
                format.html { render layout: "application2", template: "static_pages/home3"}
            end
        when "4"
            respond_to do |format|
                format.html { render layout: "application3", template: "static_pages/home4"}
            end
        else
            respond_to do |format|
                format.html { render layout: "application2", template: "static_pages/home3"}
            end
        end
	end

	def favicon
		send_file 'public/favicon.ico', type: 'image/x-icon', disposition: 'inline'
	end

end
