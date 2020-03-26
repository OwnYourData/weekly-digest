class UsersController < ApplicationController
	def index
		@heading = "MyData User Info"
		@heading_short = "User Info"
		if params[:mode].to_s == ""
			@user = User.where(status: 1)
		else
			@user = User.all
		end

        Statistic.new(
            timestamp: DateTime.now.to_i,
            url: request.headers["HTTP_REFERER"].to_s,
            source: "user_list",
            source_id: "0",
            target: "",
            target_id: nil,
            session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
        ).save


        case params[:view].to_s
        when "0"
        when "2"
			@heading = "List of All Users"
			@heading_short = "All Users"
            respond_to do |format|
                format.html { render layout: "application2", template: "users/index2"}
            end
        else
			@heading = "List of All Users"
			@heading_short = "All Users"
            respond_to do |format|
                format.html { render layout: "application2", template: "users/index2"}
            end
        end
	end

	def show
		user_id = params[:id]
		@user = User.find(user_id)
		@posts = []
		@questions = []
		@apps = []
		if @user.nil?
			@heading = "MyData User Info"
			@heading_short = "User Info"
			redirect_to users_path
			return
		else

	        Statistic.new(
	            timestamp: DateTime.now.to_i,
	            url: request.headers["HTTP_REFERER"].to_s,
	            source: "user",
	            source_id: @user.id,
	            target: "",
	            target_id: nil,
	            session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
	        ).save

			@heading = "MyData User Info for " + @user.name.to_s
			@heading_short = "User Info: " + @user.name.to_s
			@posts = Post.where(category: "info").where(user_id: user_id).order(post_date: :desc)
			@questions = Post.where(category: "question").where(user_id: user_id).order(post_date: :desc)
			@apps = App.where(id: WeeklyApp.where(user_id: user_id).pluck(:app_id))
		end

        case params[:view].to_s
        when "0"
        when "2"
			@heading = "User '" + @user.name.to_s + "'"
			@heading_short = @user.name
			@apps = WeeklyApp.where(user_id: user_id)
	        respond_to do |format|
	            format.html { render layout: "application2", template: "users/show2"}
	        end
        else
			@heading = "User '" + @user.name.to_s + "'"
			@heading_short = @user.name
			@apps = WeeklyApp.where(user_id: user_id)
	        respond_to do |format|
	            format.html { render layout: "application2", template: "users/show2"}
	        end
        end
	end
end