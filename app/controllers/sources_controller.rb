class SourcesController < ApplicationController
	def index
	end

	def show
		source_id = params[:id]
		@source = Source.find(source_id)

        case params[:view].to_s
        when "0"
            @heading = "Data Source 'ÖBB'"
            @heading_short = "ÖBB"
            respond_to do |format|
                format.html { render layout: "application2", template: "sources/show"}
            end
        else
            @heading = "Data Source 'ÖBB'"
            @heading_short = "ÖBB"
            respond_to do |format|
                format.html { render layout: "application2", template: "sources/show"}
            end
        end

	end
end
