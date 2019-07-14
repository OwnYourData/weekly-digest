# == Schema Information
#
# Table name: apps
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  status      :integer
#  title       :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class App < ApplicationRecord
	has_many :app_tags, dependent: :destroy
	has_many :weekly_apps, dependent: :destroy
end
