# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  category    :string
#  description :text
#  lang        :string
#  media_type  :string
#  media_url   :string
#  post_date   :date
#  status      :integer
#  title       :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :integer
#  user_id     :integer
#  weekly_id   :integer
#

class Post < ApplicationRecord
	has_many :posting_tags, dependent: :destroy
	has_many :post_categories, dependent: :destroy
	belongs_to :user
	belongs_to :weekly
end
