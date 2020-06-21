class NewsController < ApplicationController
    include ApplicationHelper
    include ActionView::Helpers::TextHelper
    require 'google/apis/calendar_v3'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'
    require 'redcarpet/render_strip'

    def index
        @heading = t('general.title') #"MyData Weekly Digests"
        @heading_short = "Weekly Digests"
        if params[:mode].to_s == ""
            @week = Weekly.where(status: 1)
            @app = App.where(status: 1)
        else
            @week = Weekly.all
            @app = App.all
        end

        Statistic.new(
            timestamp: DateTime.now.to_i,
            lang: I18n.locale.to_s,
            url: request.headers["HTTP_REFERER"].to_s,
            source: "weekly_list",
            source_id: "0",
            target: "",
            target_id: nil,
            session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
        ).save

        case params[:view].to_s
        when "0"
        when "2"
            @heading = "List of All MyData Weekly Digests"
            @heading_short = "All Weekly Digests"
            respond_to do |format|
                format.html { render layout: "application2", template: "news/index2"}
            end
        when "3"
            @heading = "List of All MyData Weekly Digests"
            @heading_short = "All Weekly Digests"
            respond_to do |format|
                format.html { render layout: "application2", template: "news/index2"}
            end
        when "4"
            @heading = "List of All MyData Weekly Digests"
            @heading_short = "All Weekly Digests"
            respond_to do |format|
                format.html { render layout: "application3", template: "news/index2"}
            end
        else
            @heading = "List of All MyData Weekly Digests"
            @heading_short = "All Weekly Digests"
            respond_to do |format|
                format.html { render layout: "application3", template: "news/index2"}
            end
        end

    end

    def current
        redirect_to weekly_path(Weekly.where(status: 1).last.release.to_s)
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
        @monitored_channel_names = ""
        @postings = 0
        @digest_postings = 0
        @thanks = 0
        @thanked = 0

        @previous = ""
        @next = ""
        @weekly_id = nil

        if my_date.nil?
            @heading = t('general.title')
            @heading_short = t('general.title_short')

            redirect_to root_path
            return
        else
            @og = true
            @og_date = my_date.strftime("%Y-%m-%d")
            @heading = "MyData Weekly Digest for " + my_date.strftime("%B #{my_date.day.ordinalize}, %Y")
            @heading_short = "Weekly Digest: " + my_date.strftime("%b #{my_date.day.ordinalize}, %Y")
            @weekly = Weekly.find_by_release(my_date)
            if @weekly.nil?
                redirect_to root_path
                return
            else
                @weekly_id = @weekly.id
                markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

                @it = WeeklyInternal.where(weekly_id: @weekly_id, lang: I18n.locale.to_s)
                lang_array = ["", nil, I18n.locale.to_s]
                if @it.count > 0
                    @intro_text = markdown.render(@it.first.intro.to_s)
                    if @it.first.locale_only
                        lang_array = I18n.locale.to_s
                    end
                else
                    @intro_text = markdown.render(@weekly.intro.to_s)
                end


                if params[:mode].to_s == ""
                    @weekly_scope = Weekly.where(status: 1)
                    @posts = Post.where(status: 1).where(category: "info").where(weekly_id: Weekly.find_by_release(my_date).id).where(lang: lang_array)
                    @questions = Post.where(status: 1).where(category: "question").where(weekly_id: Weekly.find_by_release(my_date).id).where(lang: lang_array)
                    @apps = WeeklyApp.where(status: 1).where(weekly_id: @weekly.id)
                else
                    @weekly_scope = Weekly.all
                    @posts = Post.where(category: "info").where(weekly_id: Weekly.find_by_release(my_date).id).where(lang: lang_array)
                    @questions = Post.where(category: "question").where(weekly_id: Weekly.find_by_release(my_date).id).where(lang: lang_array)
                    @apps = WeeklyApp.where(weekly_id: @weekly.id)
                end
                @weekly_order = @weekly_scope.order(:release)
                @previous = @weekly_order.where("release < ?", my_date).last.release.to_s rescue ""
                @next = @weekly_order.where("release > ?", my_date).first.release.to_s rescue ""

                @intro_text_plain = t('news.og_description')
                @intro_text_plain += " " + @posts.count.to_s + " " + t('news.og_desc_post', count: @posts.count)
                if @apps.count == 0
                    if @questions.count > 0
                        @intro_text_plain += " " + t('news.og_desc_and') + " " + @questions.count.to_s + " " + t('news.og_desc_quest', count: @questions.count) 
                    end
                else
                    if @questions.count > 0
                        @intro_text_plain += ", " + @questions.count.to_s + " " + t('news.og_desc_quest', count: @questions.count) 
                    end
                    @intro_text_plain += " " + t('news.og_desc_and') + " " + @apps.count.to_s + " " + t('news.og_desc_tool', count: @apps.count) 
                end
                @intro_text_plain += t('news.og_desc_end') + "."

                # @intro_text_plain += ". General comments for this week: "
                # @intro_text_plain += Redcarpet::Markdown.new(Redcarpet::Render::StripDown).render(@weekly.intro.to_s).strip.gsub(/\(\/user.*?\) /,'').gsub(/&nbsp;/,' ')

                @users = @weekly.users
                @new_users = @weekly.new_users
                @channels = @weekly.channels
                @monitored_channels = @weekly.monitored_channels
                @monitored_channel_names = @weekly.monitored_channel_names
                @postings = @weekly.postings
                @digest_postings = @posts.count + @questions.count + @apps.count
                @thanks = @weekly.thanks
                @thanked = @weekly.thanked

                service = Google::Apis::CalendarV3::CalendarService.new
                service.client_options.application_name = 'Google Calendar API Ruby Quickstart'
                service.authorization = authorize

                @events = service.list_events(
                    ENV['CALENDAR_ID'].to_s,
                    max_results: 40,
                    single_events: true,
                    order_by: 'startTime',
                    time_min: (my_date + 1.day).to_datetime.utc.iso8601,
                    time_max: (my_date + 8.days).to_datetime.utc.iso8601).items rescue []

                # @events.each do |event|
                #     start = event.start.date || event.start.date_time
                #     puts "- #{event.summary} (#{start})"
                # end

                Statistic.new(
                    timestamp: DateTime.now.to_i,
                    lang: I18n.locale.to_s,
                    url: request.headers["HTTP_REFERER"].to_s,
                    source: "weekly",
                    source_id: @weekly.id,
                    target: "",
                    target_id: nil,
                    session_id: Digest::SHA256.hexdigest(request.remote_ip.to_s + " " +  request.env['HTTP_USER_AGENT'].to_s + Rails.application.secrets.secret_key_base.to_s)
                ).save

            end
        end

        case params[:view].to_s
        when "0"
        when "2"
            respond_to do |format|
                format.html { render layout: "application2", template: "news/weekly2"}
            end
        when "3"
            respond_to do |format|
                format.html { render layout: "application2", template: "news/weekly3"}
            end
        when "4"
            @heading = t('news.page_header', :date => l(my_date, format: :long, my_day: ordinalize_number(my_date.day, I18n.locale.to_s)))
            @heading_short = t('general.title_short') + ": " + l(my_date, format: :long, my_day: ordinalize_number(my_date.day, I18n.locale.to_s))

            @it = WeeklyInternal.where(weekly_id: @weekly_id, lang: I18n.locale.to_s)
            if @it.count > 0
                @intro_text = markdown.render(@it.first.intro.to_s)
            end

            respond_to do |format|
                format.html { render layout: "application3", template: "news/weekly4"}
            end
        else
            @heading = t('news.page_header', :date => l(my_date, format: :long, my_day: ordinalize_number(my_date.day, I18n.locale.to_s)))
            @heading_short = t('general.title_short') + ": " + l(my_date, format: :long, my_day: ordinalize_number(my_date.day, I18n.locale.to_s))

            respond_to do |format|
                format.html { render layout: "application3", template: "news/weekly4"}
            end
        end
    end

    def mdi_edit
        @weekly_id = params[:id].to_s
        @lang = I18n.locale.to_s
        @locale_only = false

        @heading = t('general.title')
        @heading_short = t('general.title_short')
        @weekly = Weekly.find(@weekly_id)
        if @weekly.nil?
            redirect_to root_url
            return
        end
        my_date = Date.parse(@weekly.release.to_s) rescue Date.today
        @heading = t('news.page_header', :date => l(my_date, format: :long, my_day: ordinalize_number(my_date.day, I18n.locale.to_s)))
        @heading_short = t('general.title_short') + ": " + l(my_date, format: :long, my_day: ordinalize_number(my_date.day, I18n.locale.to_s))
        @task = "Edit"

        if @lang == "en"
            @default_text = @weekly.intro
        else
            @wi = WeeklyInternal.where(weekly_id: @weekly_id, lang: @lang)
            if @wi.nil? || @wi.count == 0
                @task = "Create localized"
                @default_text = @weekly.intro
            else
                @task = "Edit localized"
                @default_text = @wi.first.intro rescue nil
                if @wi.first.locale_only
                    @locale_only = true
                end
puts "LOCAL_ONLY: " + @locale_only.to_s                
            end
        end
        if @default_text.to_s == ""
            @default_text = "\n\n\n\n\n\n\n"
        end

        respond_to do |format|
            format.html { render layout: "application3", template: "news/edit_mdi" }
        end
    end

    def update_mdi
        @weekly = Weekly.find(params[:weekly_id])
        @lang = params[:lang].to_s
        @internal_text = params[:internal_text].to_s
        @locale_only = (params[:locale_only].to_s == "1")
puts "locale_only: " + @locale_only.to_s        

        case params[:button]
        when "save", "return"
            if @lang == "en"
                @weekly.update_attributes(intro: @internal_text)
            else
                @wi = WeeklyInternal.where(weekly_id: @weekly.id, lang: @lang)
                if @wi.nil? || @wi.count == 0
                    WeeklyInternal.new(weekly_id: @weekly.id, lang: @lang, intro: @internal_text, locale_only: @locale_only).save
                else
                    @wi.first.update_attributes(intro: @internal_text, locale_only: @locale_only)
                end
            end
            if params[:button].to_s == "save"
                redirect_to edit_mdi_url(id: @weekly.id)
            else
                redirect_to weekly_url(id: @weekly.release.to_s, mode: 0)
            end
        when "cancel"
            redirect_to weekly_url(id: @weekly.release.to_s, mode: 0)
        end
    end

    def new_wd
        @heading = t('general.title')
        @heading_short = t('general.title_short')
        @task = "New"
        @weekly_id = nil
        @release = ""
        @users = 0
        @new_users = 0
        @channels = 0
        @postings = 0
        @thanks = 0
        @thanked = 0
        @monitored_channels = 0
        @monitored_channel_names = ""
        respond_to do |format|
            format.html { render layout: "application3", template: "news/edit_wd" }
        end
    end

    def edit_wd
        @heading = t('general.title')
        @heading_short = t('general.title_short')
        @task = "Edit"
        @weekly = Weekly.find(params[:id].to_i) rescue nil
        if @weekly.nil?
            redirect_to root_url
            return
        else
            @release = @weekly.release.to_s
            @weekly_id = @weekly.id
            @users = @weekly.users
            @new_users = @weekly.new_users
            @channels = @weekly.channels
            @postings = @weekly.postings
            @thanks = @weekly.thanks
            @thanked = @weekly.thanked
            @monitored_channels = @weekly.monitored_channels
            @monitored_channel_names = @weekly.monitored_channel_names
        end
        respond_to do |format|
            format.html { render layout: "application3", template: "news/edit_wd" }
        end
    end

    def update_wd
        case params[:button].to_s
        when "save"
            if params[:weekly_id].to_s == ""
                @weekly = Weekly.new(
                    status: 0,
                    release: params[:release].to_s,
                    users: params[:users].to_i,
                    new_users: params[:new_users].to_i,
                    channels: params[:channels].to_i,
                    postings: params[:postings].to_i,
                    thanks: params[:thanks].to_i,
                    thanked: params[:thanked].to_i,
                    monitored_channels: params[:monitored_channels].to_i,
                    monitored_channel_names: params[:monitored_channel_names].to_s)
                @weekly.save
            else
                @weekly = Weekly.find(params[:weekly_id])
                @weekly.update_attributes(
                    release: params[:release].to_s,
                    users: params[:users].to_i,
                    new_users: params[:new_users].to_i,
                    channels: params[:channels].to_i,
                    postings: params[:postings].to_i,
                    thanks: params[:thanks].to_i,
                    thanked: params[:thanked].to_i,
                    monitored_channels: params[:monitored_channels].to_i,
                    monitored_channel_names: params[:monitored_channel_names].to_s)
            end
            redirect_to weekly_url(id: @weekly.release, mode: 0)
            return
        when "delete"
            if User.find(current_user).full_name.to_s == "Christoph Fabianek"
                Weekly.find(params[:weekly_id]).destroy
            end
            redirect_to root_url(mode: 0)
            return
        when "cancel"
            if params[:weekly_id].to_s != ""
                @weekly = Weekly.find(params[:weekly_id])
                if !@weekly.nil?
                    redirect_to weekly_url(id: @weekly.release, mode: 0)
                    return
                end
            end
        end
        redirect_to root_url(mode: 0)
    end

    def add_post
        @heading = t('general.title')
        @heading_short = t('general.title_short')

        @weekly_id = params[:id]
        @post_type = params[:post]
        @post_type_header = ""
        case @post_type.to_s
        when "info"
            @post_type_header = "Noteworthy Information"
        when "question"
            @post_type_header = "Question"
        end
        @post_id = nil
        @task = "Create"

        @slack_url = nil
        @post_date = nil
        @user = nil

        respond_to do |format|
            format.html { render layout: "application3", template: "news/edit_post" }
        end
    end

    def edit_post
        @heading = t('general.title')
        @heading_short = t('general.title_short')

        @weekly_id = params[:id]
        @post_id = params[:post_id]
        @post_type = params[:post]
        @post_type_header = ""
        case @post_type.to_s
        when "info"
            @post_type_header = "Noteworthy Information"
        when "question"
            @post_type_header = "Question"
        end
        @task = "Edit"

        @post = Post.find(@post_id)
        @slack_url = @post.media_url
        @post_date = @post.post_date
        @description = @post.description
        @lang = @post.lang
        @title = @post.title
        @url = @post.url
        @user = User.find(@post.user_id).name.to_s

        respond_to do |format|
            format.html { render layout: "application3", template: "news/edit_post" }
        end
    end

    def update_post
        case params[:button].to_s
        when "save", "publish"

            if User.find_by_name(params[:user]).nil?
                flash[:warning] = "Please add a valid author!"

                @heading = t('general.title')
                @heading_short = t('general.title_short')

                @weekly_id = params[:weekly_id]
                @post_id = params[:post_id]
                @post_type = params[:post_type]
                @post_type_header = ""
                case @post_type.to_s
                when "info"
                    @post_type_header = "Noteworthy Information"
                when "question"
                    @post_type_header = "Question"
                end
                if @post_id.to_s == ""
                    @post_id = nil
                    @task = "Create"
                    @slack_url = nil
                    @post_date = nil
                    @user = nil
                else
                    @task = "Edit"
                    @post = Post.find(@post_id)
                    @slack_url = @post.media_url
                    @post_date = @post.post_date
                    @description = @post.description
                    @lang = @post.lang
                    @title = @post.title
                    @url = @post.url
                    @user = User.find(@post.user_id).name.to_s
                end

                respond_to do |format|
                    format.html { render layout: "application3", template: "news/edit_post" }
                end
                return
            end

            status = 0
            if params[:button].to_s == "publish"
                status = 1
            end
            @post = Post.find(params[:post_id]) rescue nil
            if @post.nil?
                @post = Post.new(
                    category: params[:post_type].to_s,
                    description: params[:description].to_s,
                    lang: params[:lang].to_s,
                    media_type: "mydata",
                    media_url: params[:slack_url].to_s,
                    post_date: params[:post_date],
                    title: params[:title].to_s,
                    url: params[:url].to_s,
                    weekly_id: params[:weekly_id],
                    user_id: User.find_by_name(params[:user]).id,
                    author_id: current_user,
                    status: status).save
            else
                @post.update_attributes(
                    category: params[:post_type].to_s,
                    description: params[:description].to_s,
                    lang: params[:lang].to_s,
                    media_type: "mydata",
                    media_url: params[:slack_url].to_s,
                    post_date: params[:post_date],
                    title: params[:title].to_s,
                    url: params[:url].to_s,
                    weekly_id: params[:weekly_id],
                    user_id: User.find_by_name(params[:user]).id,
                    author_id: current_user,
                    status: status)
            end
        when "delete"
            @post = Post.find(params[:post_id]) rescue nil
            if !@post.nil?
                @post.destroy
            end
        end
        redirect_to weekly_url(id: Weekly.find(params[:weekly_id]).release, mode: 0)
    end

    def add_tag
        @post = Post.find(params[:tag_post_id])
        if @post.nil?
            redirect_to root_url
        end
        PostingTag.new(post_id: @post.id, tag_id: Tag.find_by_tag(params[:tag].to_s).id).save
        weekly_id = @post.weekly_id
        redirect_to weekly_url(id: Weekly.find(weekly_id).release, mode: 0)

    end

    def delete_tag
        if !logged_in?
            redirect_to root_url
            return
        end
        @pt = PostingTag.find(params[:id])
        if @pt.nil?
            redirect_to root_url(mode: 0)
            return
        end
        weekly_id = @pt.post.weekly_id
        @pt.destroy
        redirect_to weekly_url(id: Weekly.find(weekly_id).release, mode: 0)
    end


end
