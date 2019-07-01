class NewsController < ApplicationController
	def index
		@heading = "MyData Weekly Digests"
		@heading_short = "Weekly Digests"
		if params[:mode].to_s == ""
			@week = Weekly.where(status: 1)
			@app = App.where(status: 1)
		else
			@week = Weekly.all
			@app = App.all
		end

	end

	def weekly
		my_date = Date.parse(params[:id]) rescue nil

		@intro_text = ""
		@posts = []
		@questions = []
		@apps = []
		@events = []

		@users = 0
		@new_users = 0
		@channels = 0
		@monitored_channels = 0
		@postings = 0
		@digest_postings = 0
		@thanks = 0
		@thanked = 0

		@previous = ""
		@next = ""
		if my_date.nil?
			@heading = "MyData Weekly Digest"
			@heading_short = "Weekly Digest"
		else
			@heading = "MyData Weekly Digest for " + my_date.strftime("%B #{my_date.day.ordinalize}, %Y")
			@heading_short = "Weekly Digest: " + my_date.strftime("%b #{my_date.day.ordinalize}, %Y")
			@weekly = Weekly.find_by_release(my_date)
			if !@weekly.nil?
				markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

				if params[:mode].to_s == ""
					@weekly_scope = Weekly.where(status: 1)
					@posts = Post.where(status: 1).where(category: "info").where(weekly_id: Weekly.find_by_release(my_date).id)
					@questions = Post.where(status: 1).where(category: "question").where(weekly_id: Weekly.find_by_release(my_date).id)
					@apps = WeeklyApp.where(status: 1).where(weekly_id: @weekly.id)
				else
					@weekly_scope = Weekly.all
					@posts = Post.where(category: "info").where(weekly_id: Weekly.find_by_release(my_date).id)
					@questions = Post.where(category: "question").where(weekly_id: Weekly.find_by_release(my_date).id)
					@apps = WeeklyApp.where(weekly_id: @weekly.id)
				end
				@weekly_order = @weekly_scope.order(:release)
				@previous = @weekly_order.where("release < ?", my_date).last.release.to_s rescue ""
				@next = @weekly_order.where("release > ?", my_date).first.release.to_s rescue ""
				@intro_text = markdown.render(@weekly.intro.to_s)
				@events = []

				@users = @weekly.users
				@new_users = @weekly.new_users
				@channels = @weekly.channels
				@monitored_channels = @weekly.monitored_channels
				@postings = @weekly.postings
				@digest_postings = @posts.count + @questions.count + @apps.count
				@thanks = @weekly.thanks
				@thanked = @weekly.thanked
			end
		end
	end
end