class UsersController < ApplicationController
	def index
		@heading = "MyData User Info"
		@heading_short = "User Info"
		if params[:mode].to_s == ""
			@user = User.where(status: 1)
		else
			@user = User.all
		end

        if params[:view].to_s != ""
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
		else
			@heading = "MyData User Info for " + @user.name.to_s
			@heading_short = "User Info: " + @user.name.to_s
			@posts = Post.where(category: "info").where(user_id: user_id).order(post_date: :desc)
			@questions = Post.where(category: "question").where(user_id: user_id).order(post_date: :desc)
			@apps = App.where(id: WeeklyApp.where(user_id: user_id).pluck(:app_id))
		end

	    if params[:view].to_s != ""
			@heading = "User '" + @user.name.to_s + "'"
			@heading_short = @user.name
			@apps = WeeklyApp.where(user_id: user_id)
	        respond_to do |format|
	            format.html { render layout: "application2", template: "users/show2"}
	        end
	    end


	end
end