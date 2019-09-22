# == Schema Information
#
# Table name: apps
#
#  id                :bigint(8)        not null, primary key
#  available_since   :string
#  description       :text
#  image_url         :string
#  license           :string
#  mydata_membership :string
#  status            :integer
#  title             :string
#  url               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer
#

class App < ApplicationRecord
	has_many :app_tags, dependent: :destroy
	has_many :weekly_apps, dependent: :destroy
	has_many :app_ratings, dependent: :destroy
	has_many :source_tools, dependent: :destroy
	belongs_to :user
end
