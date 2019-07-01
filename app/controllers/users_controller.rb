class UsersController < ApplicationController
	def index
		@heading = "MyData User Info"
		@heading_short = "User Info"
		if params[:mode].to_s == ""
			@user = User.where(status: 1)
		else
			@user = User.all
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
	end
end