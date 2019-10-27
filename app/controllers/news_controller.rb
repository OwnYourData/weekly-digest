class NewsController < ApplicationController
    include ApplicationHelper
    require 'google/apis/calendar_v3'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'
    require 'redcarpet/render_strip'

    def index
        @heading = "MyData Weekly Digests"
        @heading_short = "Weekly Digests"
        if params[:mode].to_s == ""
            @week = Weekly.where(status: 1)
            @app = App.where(status: 1)
        else
            @week = Weekly.all
            @app = App.all
        end

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
        if my_date.nil?
            @heading = "MyData Weekly Digest"
            @heading_short = "Weekly Digest"
        else
            @og = true
            @og_date = my_date.strftime("%Y-%m-%d")
            @heading = "MyData Weekly Digest for " + my_date.strftime("%B #{my_date.day.ordinalize}, %Y")
            @heading_short = "Weekly Digest: " + my_date.strftime("%b #{my_date.day.ordinalize}, %Y")
            @weekly = Weekly.find_by_release(my_date)
            if !@weekly.nil?
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
                @intro_text_plain = Redcarpet::Markdown.new(Redcarpet::Render::StripDown).render(@weekly.intro.to_s).strip.gsub(/\(\/user.*?\) /,'').gsub(/&nbsp;/,' ')

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

            end
        end

        case params[:view].to_s
        when "0"
        when "2"
            respond_to do |format|
                format.html { render layout: "application2", template: "news/weekly2"}
            end
        else
            respond_to do |format|
                format.html { render layout: "application2", template: "news/weekly2"}
            end
        end
    end
end