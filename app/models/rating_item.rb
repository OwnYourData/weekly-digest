# == Schema Information
#
# Table name: rating_items
#
#  id         :bigint(8)        not null, primary key
#  group      :string
#  info_url   :string
#  string     :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RatingItem < ApplicationRecord
	has_many :app_rating_items
end
