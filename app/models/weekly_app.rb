# == Schema Information
#
# Table name: weekly_apps
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  media_type  :string
#  media_url   :string
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  app_id      :integer
#  user_id     :integer
#  weekly_id   :integer
#

class WeeklyApp < ApplicationRecord
end
