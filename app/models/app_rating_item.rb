# == Schema Information
#
# Table name: app_rating_items
#
#  id             :bigint(8)        not null, primary key
#  comment        :text
#  rating         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  app_rating_id  :integer
#  rating_item_id :integer
#

class AppRatingItem < ApplicationRecord
	belongs_to :app_rating
	belongs_to :rating_item
end
