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
        else
            @heading = "List of All MyData Weekly Digests"
            @heading_short = "All Weekly Digests"
            respond_to do |format|
                format.html { render layout: "application2", template: "news/index2"}
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
            @heading = "MyData Weekly Digest"
            @heading_short = "Weekly Digest"

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

                if params[:mode].to_s == ""
                    @weekly_scope = Weekly.where(status: 1)
                    @posts = Post.where(status: 1).where(category: "info").where(weekly_id: Weekly.find_by_release(my_date).id)
                    @questions = Post.where(status: 1).where(category: "question").where(weekly_id: Weekly.find_by_release(my_date).id)
                    @apps = WeeklyApp.where(status: 1).where(weekly_id: @weekly.id)
                else
                    @weekly_scope = Weekly.all
                    @posts = Post.where(category: "info").where(weekly_id: Weekly.find_by_release(my_date).id)
                    @questions = Post.where(category: "question").where(weekly_id: Weekly.find_by_release(my_date).id)
                    @apps = WeeklyApp.where(weekly_id: @weekly.id)
                end
                @weekly_order = @weekly_scope.order(:release)
                @previous = @weekly_order.where("release < ?", my_date).last.release.to_s rescue ""
                @next = @weekly_order.where("release > ?", my_date).first.release.to_s rescue ""
                @intro_text = markdown.render(@weekly.intro.to_s)
                @intro_text_plain = "Read in this weeks digest about " + pluralize(@posts.count, "noteworthy post")
                if @apps.count == 0
                    if @questions.count > 0
                        @intro_text_plain += " and " + pluralize(@questions.count, "question") + " asked"
                    end
                else
                    if @questions.count > 0
                        @intro_text_plain += ", " + pluralize(@questions.count, "question") + " asked, and " + pluralize(@apps.count, "personal data tool")
                    else
                        @intro_text_plain += " and " + pluralize(@apps.count, "personal data tool")
                    end
                end
                @intro_text_plain += "."
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
            respond_to do |format|
                format.html { render layout: "application2", template: "news/weekly3"}
            end
        end
    end
end