xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t('general.title')
    xml.description t('general.description')
    xml.link root_url

    for issue in @week
      xml.item do
        my_date = Date.parse(issue.release.to_s) rescue Date.today
        xml.title t('news.page_header', :date => l(my_date, format: :long, my_day: ordinalize_number(my_date.day, I18n.locale.to_s)))
        xml.description t('news.og_description') + ": " + (issue.posts.where(category: "info").count).to_s + " " + t('news.post', count: issue.posts.where(category: "info").count) + (issue.posts.where(category: "question").count == 0 ? "" : ", " + (issue.posts.where(category: "question").count).to_s + " " + t('news.question', count: issue.posts.where(category: "question").count)) + (issue.weekly_apps.count == 0 ? "" : ", " + issue.weekly_apps.count.to_s + " " + t('news.tool', count: issue.weekly_apps.count))
        xml.pubDate issue.release.to_s
        xml.link "https://weekly-digest.ownyourdata.eu/" + I18n.locale.to_s + "/weekly/" + issue.release.to_s
        xml.guid "https://weekly-digest.ownyourdata.eu/" + I18n.locale.to_s + "/weekly/" + issue.release.to_s
      end
    end
  end
end
