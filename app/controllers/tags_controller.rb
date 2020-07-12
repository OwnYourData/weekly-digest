class TagsController < ApplicationController
	def index
		@heading = "MyData Tag Info"
		@heading_short = "Tag Info"
		if params[:mode].to_s == ""
			@tag = Tag.where(status: 1)
		else
			@tag = Tag.all
		end
        Statistic.new(
            timestamp: DateTime.now.to_i,
            lang: I18n.locale.to_s,
            url: request.headers["HTTP_REFERER"].to_s,
            source: "tag_list",
            source_id: 0,
            target: "",
            target_id: nil,
            session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
        ).save

        case params[:view].to_s
        when "0"
        when "2"
			@heading = "List of All Tags"
			@heading_short = "All Tags"
            respond_to do |format|
                format.html { render layout: "application2", template: "tags/index2"}
            end
        when "3"
			@heading = "List of All Tags"
			@heading_short = "All Tags"
            respond_to do |format|
                format.html { render layout: "application2", template: "tags/index2"}
            end
        when "4"
			@heading = t('tag.title')
			@heading_short = t('tag.title_short')
            respond_to do |format|
                format.html { render layout: "application3", template: "tags/index2"}
            end
        else
			@heading = t('tag.title')
			@heading_short = t('tag.title_short')
            respond_to do |format|
                format.html { render layout: "application3", template: "tags/index2"}
            end
        end
	end

	def show
		tag_id = params[:id]
		@tag = Tag.find(tag_id) rescue nil
		@posts = []
		@questions = []
		@apps = []
		@sources = []
		if @tag.nil?
			@heading = "MyData Tag Info"
			@heading_short = "Tag Info"
			redirect_to tags_path
			return
		else
	        Statistic.new(
	            timestamp: DateTime.now.to_i,
	            lang: I18n.locale.to_s,
	            url: request.headers["HTTP_REFERER"].to_s,
	            source: "tag",
	            source_id: @tag.id,
	            target: "",
	            target_id: nil,
	            session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
	        ).save

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
        when "3"
	    	@apps = WeeklyApp.where(app_id: AppTag.where(tag_id: tag_id).pluck(:app_id))
			@heading = "Tag #" + @tag.tag.to_s
			@heading_short = "#" + @tag.tag.to_s
	        respond_to do |format|
	            format.html { render layout: "application2", template: "tags/show2"}
	        end
        when "4"
	    	@apps = WeeklyApp.where(app_id: AppTag.where(tag_id: tag_id).pluck(:app_id))
			@heading = t('tag.tag') + " #" + @tag.tag.to_s
			@heading_short = "#" + @tag.tag.to_s
	        respond_to do |format|
	            format.html { render layout: "application3", template: "tags/show2"}
	        end
        else
	    	@apps = WeeklyApp.where(app_id: AppTag.where(tag_id: tag_id).pluck(:app_id))
			@heading = t('tag.tag') + " #" + @tag.tag.to_s
			@heading_short = "#" + @tag.tag.to_s
	        respond_to do |format|
	            format.html { render layout: "application3", template: "tags/show2"}
	        end
        end
	end

	def destroy
		tag_id = params[:id]
		@tag = Tag.find(tag_id)
		if !@tag.nil?
			if (@tag.posting_tags.count + @tag.app_tags.count + @tag.source_tags.count) == 0
				@tag.destroy
			end
		end
		redirect_to tags_path
	end
end