module ApplicationHelper
    require 'google/apis/calendar_v3'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'

	def view_mode
		if params[:mode].to_s == ""
            if params[:view].to_s == ""
                ""
            else
                "?view=" + params[:view].to_s
            end
		else
            if params[:view].to_s == ""
                "?mode=" + params[:mode].to_s
            else
                "?mode=" + params[:mode].to_s + "&view=" + params[:view].to_s
            end
		end
	end

    def authorize
        client_id = Google::Auth::ClientId.new(
            ENV['CALENDAR_KEY'].to_s, 
            ENV['CALENDAR_SECRET'].to_s)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: 'token.yaml')
        authorizer = Google::Auth::UserAuthorizer.new(
            client_id, 
            Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY, 
            token_store)
        user_id = 'default'
        credentials = authorizer.get_credentials(user_id) rescue nil
        if credentials.nil?
            code = ENV['CALENDAR_CODE'].to_s
            credentials = authorizer.get_and_store_credentials_from_code(
                user_id: user_id, 
                code: code, 
                base_url: 'urn:ietf:wg:oauth:2.0:oob') rescue nil
        end
        credentials
    end
    
    def ordinalize_number number, my_locale
        case my_locale.to_s
        when "en"
            return number.ordinalize
        else
            return number
        end
    end

    def getWeekCount(weekly_id, lang)
        info_cnt = 0
        quest_cnt = 0
        app_cnt = 0
        mydata_cnt = 0

        @week = Weekly.find(weekly_id)
        if !@week.nil?
            @it = WeeklyInternal.where(weekly_id: weekly_id, lang: lang)
            lang_array = ["", nil, lang]
            if lang == "en"
                intro_text = @week["intro"].to_s
            else
                if @it.count > 0
                    intro_text = @it.first.intro.to_s
                    if @it.first.locale_only
                        lang_array = lang
                    end
                else
                    intro_text = @week["intro"].to_s
                end
            end
            info_cnt = @week.posts.where(category: "info").where(lang: lang_array).count rescue 0
            quest_cnt = @week.posts.where(category: "question").where(lang: lang_array).count rescue 0
            app_cnt = @week.weekly_apps.count rescue 0
            mydata_cnt = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true).render(intro_text).scan(/<li>/).length rescue 0
        end
        return info_cnt, quest_cnt, app_cnt, mydata_cnt
    end

    def getWeekCountText(weekly_id, lang, text_style = "default")
        retVal = ""
        info_cnt, quest_cnt, app_cnt, mydata_cnt = getWeekCount(weekly_id, lang)

        case text_style
        when "social"
            info_str = 'news.og_desc_post'
            quest_str = 'news.og_desc_quest'
            app_str = 'news.og_desc_tool'
            mydata_str = 'news.talking_point'
        else
            info_str = 'news.post'
            quest_str = 'news.question'
            app_str = 'news.tool'
            mydata_str = 'news.talking_point'
        end

        txt_pieces = []
        if info_cnt > 0
            txt_pieces << info_cnt.to_s + " " + t(info_str, count: info_cnt)
        end
        if quest_cnt > 0
            txt_pieces << quest_cnt.to_s + " " + t(quest_str, count: quest_cnt)
        end
        if app_cnt > 0
            txt_pieces << app_cnt.to_s + " " + t(app_str, count: app_cnt)
        end
        if mydata_cnt > 0
            txt_pieces << mydata_cnt.to_s + " " + t(mydata_str, count: mydata_cnt)
        end

        case txt_pieces.length
        when 0
            retVal = ""
        when 1
            retVal = txt_pieces.first
        when 2
            retVal = txt_pieces.first + " " + t('news.og_desc_and') + " " + txt_pieces.last
        else
            retVal = txt_pieces.first(txt_pieces.length - 2).join(", ") + ", " + txt_pieces.last(2).first + " " + t('news.og_desc_and') + " " + txt_pieces.last
        end
        return retVal
    end
end
