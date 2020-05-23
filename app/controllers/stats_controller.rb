class StatsController < ApplicationController
	require 'digest'

	def index
		if params[:password].to_s == ENV["STATS_PASSWORD"].to_s && params[:password].to_s.length > 0
			if params[:last].to_s == ""
				render json: Statistic.all.to_json,
					   status: 200
			else
				render json: Statistic.last(params[:last].to_i).to_json,
					   status: 200
			end
		else
			render json: [],
				   status: 200
		end
	end

	def data
		Statistic.new(
			timestamp: DateTime.now.to_i,
			lang: I18n.locale.to_s,
			source: params[:stats_source].to_s,
			source_id: params[:stats_source_id],
			target: params[:stats_target].to_s,
			target_id: params[:stats_target_id],
			session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
		).save
		head 200, content_type: "text/html"
		# redirect_to params[:l].to_s
	end
end

