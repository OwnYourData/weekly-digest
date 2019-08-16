class TagsController < ApplicationController
	def index
		@heading = "MyData Tag Info"
		@heading_short = "Tag Info"
		if params[:mode].to_s == ""
			@tag = Tag.where(status: 1)
		else
			@tag = Tag.all
		end

        if params[:view].to_s != ""
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
		if @tag.nil?
			@heading = "MyData Tag Info"
			@heading_short = "Tag Info"
		else
			@heading = "MyData Tag Info for #" + @tag.tag.to_s
			@heading_short = "Tag Info: #" + @tag.tag.to_s
			@posts = Post.where(category: "info").where(id: PostingTag.where(tag_id: tag_id).pluck(:post_id))
			@questions = Post.where(category: "question").where(id: PostingTag.where(tag_id: tag_id).pluck(:post_id))
			@apps = AppTag.where(tag_id: tag_id)
		end

	    if params[:view].to_s != ""
			@heading = "Tag #" + @tag.tag.to_s
			@heading_short = "#" + @tag.tag.to_s
	        respond_to do |format|
	            format.html { render layout: "application2", template: "tags/show2"}
	        end
	    end
	end


end