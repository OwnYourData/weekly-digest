# == Schema Information
#
# Table name: sources
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  request     :text
#  response    :text
#  status      :integer
#  title       :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Source < ApplicationRecord
	has_many :source_tags, dependent: :destroy
	has_many :source_reports, dependent: :destroy
	has_many :source_tools, dependent: :destroy
	belongs_to :user
end
