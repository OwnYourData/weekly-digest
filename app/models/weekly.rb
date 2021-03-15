# == Schema Information
#
# Table name: weeklies
#
#  id                      :integer          not null, primary key
#  channels                :integer
#  intro                   :text
#  monitored_channel_names :text
#  monitored_channels      :integer
#  new_users               :integer
#  postings                :integer
#  release                 :date
#  status                  :integer
#  thanked                 :integer
#  thanks                  :integer
#  users                   :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Weekly < ApplicationRecord
	has_many :posts, dependent: :destroy
	has_many :weekly_apps, dependent: :destroy
	has_many :weekly_internals, dependent: :destroy
end
