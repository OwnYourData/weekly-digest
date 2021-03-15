class WeeklyMailer < ApplicationMailer
    include ApplicationHelper

    def send_email(to)
        @email = to
        @subscription = Subscription.find_by_email(to)
        @key = @subscription.key.to_s
        @lang = @subscription.lang || "en"

        @weekly = Weekly.where(status: 1).last
        # @weekly = Weekly.where(release: "2020-08-14").first
        my_date = Date.parse(@weekly.release.to_s) rescue nil
        @heading = t('news.page_header', :date => l(my_date, format: :long, my_day: ordinalize_number(my_date.day, @lang), locale: @lang), :locale => @lang)

        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
        @it = WeeklyInternal.where(weekly_id: @weekly.id, lang: @lang)
        lang_array = ["", nil, @lang]
        if @it.count > 0
            @intro_text = markdown.render(@it.first.intro.to_s)
            if @it.first.locale_only
                lang_array = @lang
            end
        else
            @intro_text = markdown.render(@weekly.intro.to_s)
        end

        @posts = Post.where(status: 1).where(category: "info").where(weekly_id: @weekly.id).where(lang: lang_array)
        @questions = Post.where(status: 1).where(category: "question").where(weekly_id: @weekly.id).where(lang: lang_array)
        @apps = WeeklyApp.where(status: 1).where(weekly_id: @weekly.id)


        mail(to: to, subject: @heading)
    end
end
