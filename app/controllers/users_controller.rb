class UsersController < ApplicationController
    def index
        @heading = "MyData User Info"
        @heading_short = "User Info"
        if params[:mode].to_s == ""
            @user = User.where(status: 1)
        else
            @user = User.all
        end

        if params[:term]
            @users = User.search_by_full_name(params[:term]).with_pg_search_highlight
        end


        Statistic.new(
            timestamp: DateTime.now.to_i,
            lang: I18n.locale.to_s,
            url: request.headers["HTTP_REFERER"].to_s,
            source: "user_list",
            source_id: "0",
            target: "",
            target_id: nil,
            session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
        ).save


        case params[:view].to_s
        when "0"
        when "2"
            @heading = "List of All Users"
            @heading_short = "All Users"
            respond_to do |format|
                format.html { render layout: "application2", template: "users/index2"}
            end
        when "3"
            @heading = "List of All Users"
            @heading_short = "All Users"
            respond_to do |format|
                format.html { render layout: "application2", template: "users/index2"}
            end
        when "4"
            @heading = t('user.title') # "List of All Users"
            @heading_short = t('user.title_short') # "All Users"
            respond_to do |format|
                format.html { render layout: "application3", template: "users/index2"}
            end
        else
            @heading = t('user.title')
            @heading_short = t('user.title_short')
            respond_to do |format|
                format.html { render layout: "application3", template: "users/index2"}
            end
        end
    end

    def show
        user_id = params[:id]
        @user = User.find(user_id) rescue nil
        if @user.nil?
            redirect_to root_path
            return
        end
        @posts = []
        @questions = []
        @apps = []
        if @user.nil?
            @heading = "MyData User Info"
            @heading_short = "User Info"
            redirect_to users_path
            return
        else

            Statistic.new(
                timestamp: DateTime.now.to_i,
                lang: I18n.locale.to_s,
                url: request.headers["HTTP_REFERER"].to_s,
                source: "user",
                source_id: @user.id,
                target: "",
                target_id: nil,
                session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
            ).save

            @heading = "MyData User Info for " + @user.name.to_s
            @heading_short = "User Info: " + @user.name.to_s
            @posts = Post.where(category: "info").where(user_id: user_id).order(post_date: :desc)
            @questions = Post.where(category: "question").where(user_id: user_id).order(post_date: :desc)
            @apps = App.where(id: WeeklyApp.where(user_id: user_id).pluck(:app_id))
        end

        case params[:view].to_s
        when "0"
        when "2"
            @heading = "User '" + @user.name.to_s + "'"
            @heading_short = @user.name
            @apps = WeeklyApp.where(user_id: user_id)
            respond_to do |format|
                format.html { render layout: "application2", template: "users/show2"}
            end
        when "3"
            @heading = "User '" + @user.name.to_s + "'"
            @heading_short = @user.name
            @apps = WeeklyApp.where(user_id: user_id)
            respond_to do |format|
                format.html { render layout: "application2", template: "users/show2"}
            end
        when "4"
            @heading = t('user.user') + " '" + @user.name.to_s + "'"
            @heading_short = @user.name
            @apps = WeeklyApp.where(user_id: user_id)
            respond_to do |format|
                format.html { render layout: "application3", template: "users/show2"}
            end
        else
            @heading = t('user.user') + " '" + @user.name.to_s + "'"
            @heading_short = @user.name
            @apps = WeeklyApp.where(user_id: user_id)
            respond_to do |format|
                format.html { render layout: "application3", template: "users/show2"}
            end
        end
    end

    def destroy
        user_id = params[:id]
        @user = User.find(user_id)
        if !@user.nil?
            if (@user.posts.count + @user.weekly_apps.count + @user.apps.count + @user.sources.count) == 0
                @user.destroy
            end
        end
        redirect_to users_path
    end    
end