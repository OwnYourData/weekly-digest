# == Schema Information
#
# Table name: app_ratings
#
#  id         :bigint(8)        not null, primary key
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  app_id     :integer
#  user_id    :integer
#

class AppRating < ApplicationRecord
	belongs_to :app
	belongs_to :user
	has_many :app_rating_items, dependent: :destroy
end
