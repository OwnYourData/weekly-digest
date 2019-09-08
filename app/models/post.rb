# == Schema Information
#
# Table name: posts
#
#  id          :bigint(8)        not null, primary key
#  category    :string
#  description :text
#  media_type  :string
#  media_url   :string
#  post_date   :date
#  status      :integer
#  title       :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  weekly_id   :integer
#

class Post < ApplicationRecord
	has_many :posting_tags, dependent: :destroy
	belongs_to :user
	belongs_to :weekly
end
