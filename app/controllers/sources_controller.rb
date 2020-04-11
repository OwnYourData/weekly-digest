class SourcesController < ApplicationController
	def index
        @heading = "MyData Data Sources"
        @heading_short = "Data Sources"
        if params[:mode].to_s == ""
            @source = Source.where(status: 1)
        else
            @source = Source.all
        end

        case params[:view].to_s
        when "0"
            @heading = "List of All Data Sources"
            @heading_short = "All Data Sources"
            respond_to do |format|
                format.html { render layout: "application2", template: "sources/index"}
            end
        when "3"
            @heading = "List of All Data Sources"
            @heading_short = "All Data Sources"
            respond_to do |format|
                format.html { render layout: "application2", template: "sources/index"}
            end
        when "4"
            @heading = "List of All Data Sources"
            @heading_short = "All Data Sources"
            respond_to do |format|
                format.html { render layout: "application3", template: "sources/index"}
            end
        else
            @heading = "List of All Data Sources"
            @heading_short = "All Data Sources"
            respond_to do |format|
                format.html { render layout: "application3", template: "sources/index"}
            end
        end
	end

	def show
		source_id = params[:id]
		@source = Source.find(source_id)

        @heading = "Data Source '" + @source.title.to_s + "'"
        @heading_short = @source.title.to_s

        case params[:view].to_s
        when "0"
            respond_to do |format|
                format.html { render layout: "application2", template: "sources/show"}
            end
        when "3"
            respond_to do |format|
                format.html { render layout: "application2", template: "sources/show"}
            end
        when "4"
            respond_to do |format|
                format.html { render layout: "application3", template: "sources/show"}
            end
        else
            respond_to do |format|
                format.html { render layout: "application3", template: "sources/show"}
            end
        end

	end
end
