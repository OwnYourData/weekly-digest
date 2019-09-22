class TagsController < ApplicationController
	def index
		@heading = "MyData Tag Info"
		@heading_short = "Tag Info"
		if params[:mode].to_s == ""
			@tag = Tag.where(status: 1)
		else
			@tag = Tag.all
		end

        case params[:view].to_s
        when "0"
        when "2"
			@heading = "List of All Tags"
			@heading_short = "All Tags"
            respond_to do |format|
                format.html { render layout: "application2", template: "tags/index2"}
            end
        else
			@heading = "List of All Tags"
			@heading_short = "All Tags"
            respond_to do |format|
                format.html { render layout: "application2", template: "tags/index2"}
            end
        end
	end

	def show
		tag_id = params[:id]
		@tag = Tag.find(tag_id)
		@posts = []
		@questions = []
		@apps = []
		@sources = []
		if @tag.nil?
			@heading = "MyData Tag Info"
			@heading_short = "Tag Info"
		else
			@heading = "MyData Tag Info for #" + @tag.tag.to_s
			@heading_short = "Tag Info: #" + @tag.tag.to_s
			@posts = Post.where(category: "info").where(id: PostingTag.where(tag_id: tag_id).pluck(:post_id))
			@questions = Post.where(category: "question").where(id: PostingTag.where(tag_id: tag_id).pluck(:post_id))
			@apps = AppTag.where(tag_id: tag_id)
			@sources = SourceTag.where(tag_id: tag_id)
		end

        case params[:view].to_s
        when "0"
        when "2"
	    	@apps = WeeklyApp.where(app_id: AppTag.where(tag_id: tag_id).pluck(:app_id))
			@heading = "Tag #" + @tag.tag.to_s
			@heading_short = "#" + @tag.tag.to_s
	        respond_to do |format|
	            format.html { render layout: "application2", template: "tags/show2"}
	        end
        else
	    	@apps = WeeklyApp.where(app_id: AppTag.where(tag_id: tag_id).pluck(:app_id))
			@heading = "Tag #" + @tag.tag.to_s
			@heading_short = "#" + @tag.tag.to_s
	        respond_to do |format|
	            format.html { render layout: "application2", template: "tags/show2"}
	        end
        end
	end
end