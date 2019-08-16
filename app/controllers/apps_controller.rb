class AppsController < ApplicationController
	def index
		@heading = "MyData Apps & Services"
		@heading_short = "Apps & Services"
		if params[:mode].to_s == ""
			@app = App.where(status: 1)
		else
			@app = App.all
		end
        if params[:view].to_s != ""
			@heading = "List of All Apps & Services"
			@heading_short = "All Apps & Services"
            respond_to do |format|
                format.html { render layout: "application2", template: "apps/index2"}
            end
        end
	end

	def show
		app_id = params[:id]
		@app = App.find(app_id)
		@posts = []
		if @app.nil?
			@heading = "MyData Apps & Services"
			@heading_short = "Apps & Services"
		else
			@heading = "Apps & Services: " + @app.title.to_s
			@heading_short = @app.title.to_s
			if params[:mode].to_s == ""
				@posts = @app.weekly_apps.where(status: 1)
			else 
				@posts = @app.weekly_apps
			end
		end

        if params[:view].to_s != ""
            respond_to do |format|
                format.html { render layout: "application2", template: "apps/show2"}
            end
        end

	end
end