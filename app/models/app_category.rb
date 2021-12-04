# == Schema Information
#
# Table name: app_categories
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  app_id      :integer
#  category_id :integer
#
class AppCategory < ApplicationRecord
	belongs_to :app
	belongs_to :category
end
