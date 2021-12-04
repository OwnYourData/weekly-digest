class AppsController < ApplicationController
    def index
        @heading = "MyData Tools"
        @heading_short = "Tools"
        if params[:mode].to_s == ""
            @app = App.where(status: 1)
        else
            @app = App.all
        end

        Statistic.new(
            timestamp: DateTime.now.to_i,
            lang: I18n.locale.to_s,
            url: request.headers["HTTP_REFERER"].to_s,
            source: "tool_list",
            source_id: "0",
            target: "",
            target_id: nil,
            session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
        ).save

        case params[:view].to_s
        when "0"
        when "2"
            @heading = "List of All Tools"
            @heading_short = "All Tools"
            respond_to do |format|
                format.html { render layout: "application2", template: "apps/index2"}
            end
        when "3"
            @heading = "List of All Tools"
            @heading_short = "All Tools"
            respond_to do |format|
                format.html { render layout: "application2", template: "apps/index2"}
            end
        when "4"
            @heading = "List of All Tools"
            @heading_short = "All Tools"
            respond_to do |format|
                format.html { render layout: "application3", template: "apps/index2"}
            end
        else
            @heading = "List of All Tools"
            @heading_short = "All Tools"
            respond_to do |format|
                format.html { render layout: "application3", template: "apps/index2"}
            end
        end
    end

    def new
        @heading = t('general.title')
        @heading_short = t('general.title_short')

        @app_id = nil
        @users = 0

        respond_to do |format|
            format.html { render layout: "application3", template: "apps/new" }
        end
    end

    def edit
        @heading = t('general.title')
        @heading_short = t('general.title_short')

        @app_id = params[:id]
        @app = App.find(@app_id) rescue nil
        @user = User.find(@app.user_id).name.to_s
        @title = @app.title
        @description = @app.description
        @url = @app.url
        @cat_1 = ""
        @cat_2 = ""
        if AppCategory.where(app_id: @app_id, category_id: 1).count > 0
            @cat_2 = "simple"
        end
        if AppCategory.where(app_id: @app_id, category_id: 2).count > 0
            @cat_2 = "intermediate"
        end
        if AppCategory.where(app_id: @app_id, category_id: 3).count > 0
            @cat_2 = "advanced"
        end
        if AppCategory.where(app_id: @app_id, category_id: 4).count > 0
            @cat_1 = "individual"
        end
        if AppCategory.where(app_id: @app_id, category_id: 5).count > 0
            @cat_1 = "business"
        end
        if AppCategory.where(app_id: @app_id, category_id: 6).count > 0
            @cat_1 = "developer"
        end


        respond_to do |format|
            format.html { render layout: "application3", template: "apps/new" }
        end
    end

    def update
        case params[:button].to_s
        when "save", "publish"
            if User.find_by_name(params[:user]).nil?
                if params[:user].to_s.strip == ""
                    flash[:warning] = "Please add a valid author!"
                    redirect_to new_app_url
                    return
                else
                    User.new(name: params[:user].to_s, status: 1, password:" ", password_confirmation:" ").save
                end
            end

            status = 0
            if params[:button].to_s == "publish"
                status = 1
            end

            @app = App.find(params[:app_id]) rescue nil
            if @app.nil?
                @app = App.new(
                    description: params[:description].to_s,
                    title: params[:title].to_s,
                    url: params[:url].to_s,
                    user_id: User.find_by_name(params[:user]).id,
                    status: status)
                @app.save
            else
                @app.update_attributes(
                    description: params[:description].to_s,
                    title: params[:title].to_s,
                    url: params[:url].to_s,
                    user_id: User.find_by_name(params[:user]).id,
                    status: status)
            end

            AppCategory.where(app_id: @app.id).destroy_all
            case params[:cat_1].to_s
            when "individual"
                AppCategory.new(app_id: @app.id, category_id: 4).save
            when "business"
                AppCategory.new(app_id: @app.id, category_id: 5).save
            when "developer"
                AppCategory.new(app_id: @app.id, category_id: 6).save
            end
            case params[:cat_2].to_s
            when "simple"
                AppCategory.new(app_id: @app.id, category_id: 1).save
            when "intermediate"
                AppCategory.new(app_id: @app.id, category_id: 2).save
            when "advanced"
                AppCategory.new(app_id: @app.id, category_id: 3).save
            end

        when "delete"
            @app = App.find(params[:app_id]) rescue nil
            if !@app.nil?
                @app.destroy
            end
        end
        redirect_to tools_url
    end

    def show
        app_id = params[:id]
        @app = App.find(app_id) rescue nil
        @posts = []
        if @app.nil?
            @heading = "MyData Tools"
            @heading_short = "Tools"
            redirect_to tools_path
            return
        else

            Statistic.new(
                timestamp: DateTime.now.to_i,
                lang: I18n.locale.to_s,
                url: request.headers["HTTP_REFERER"].to_s,
                source: "tool",
                source_id: @app.id,
                target: "",
                target_id: nil,
                session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
            ).save

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
        when "4"
            respond_to do |format|
                format.html { render layout: "application3", template: "apps/show3"}
            end
        else
            respond_to do |format|
                format.html { render layout: "application3", template: "apps/show3"}
            end
        end

    end
end