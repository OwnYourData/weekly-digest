# == Schema Information
#
# Table name: weeklies
#
#  id                      :bigint(8)        not null, primary key
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
end
