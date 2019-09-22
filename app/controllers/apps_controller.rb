class AppsController < ApplicationController
    def index
        @heading = "MyData Tools"
        @heading_short = "Tools"
        if params[:mode].to_s == ""
            @app = App.where(status: 1)
        else
            @app = App.all
        end

        case params[:view].to_s
        when "0"
        when "2"
            @heading = "List of All Tools"
            @heading_short = "All Tools"
            respond_to do |format|
                format.html { render layout: "application2", template: "apps/index2"}
            end
        else
            @heading = "List of All Tools"
            @heading_short = "All Tools"
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
            @heading = "MyData Tools"
            @heading_short = "Tools"
        else
            @heading = "Tool: " + @app.title.to_s
            @heading_short = @app.title.to_s

            @sector_tags = @app.app_tags.where(tag_id: Tag.where(group: "sector").pluck(:id))
            @process_tags = @app.app_tags.where(tag_id: Tag.where(group: "process").pluck(:id))
            @other_tags = @app.app_tags.where.not(tag_id: Tag.where(group: "sector").or(Tag.where(group: "process")).pluck(:id))

            if params[:mode].to_s == ""
                @posts = @app.weekly_apps.where(status: 1)
            else 
                @posts = @app.weekly_apps
            end

            @similar = []
            AppTag.where(tag_id: @app.app_tags.pluck(:tag_id)).
                pluck(:app_id).
                inject(Hash.new(0)){|h, e| h[e]+=1; h}.
                sort_by(&:last).reverse.
                each{|x| @similar << x.first unless x.first == @app.id}

            @user_ratings = @app.app_ratings
            org_tmp = AppRatingItem.where(
                        app_rating_id: AppRating.where(app_id: @app.id).pluck(:id), 
                        rating_item_id: RatingItem.where(group: "organization").pluck(:id)).pluck(:rating).compact
            @organization_rating = org_tmp.sum.to_f / org_tmp.size

            tool_tmp = AppRatingItem.where(
                        app_rating_id: AppRating.where(app_id: @app.id).pluck(:id), 
                        rating_item_id: RatingItem.where(group: "tool").pluck(:id)).pluck(:rating).compact
            @tool_rating = tool_tmp.sum.to_f / tool_tmp.size

            imp_tmp = AppRatingItem.where(
                        app_rating_id: AppRating.where(app_id: @app.id).pluck(:id), 
                        rating_item_id: RatingItem.where(group: "impact").pluck(:id)).pluck(:rating).compact
            @impact_rating = imp_tmp.sum.to_f / imp_tmp.size
        end

        case params[:view].to_s
        when "0"
        when "2"
            respond_to do |format|
                format.html { render layout: "application2", template: "apps/show2"}
            end
        when "3"
            respond_to do |format|
                format.html { render layout: "application2", template: "apps/show3"}
            end
        else
            respond_to do |format|
                format.html { render layout: "application2", template: "apps/show3"}
            end
        end

    end
end