# == Schema Information
#
# Table name: post_categories
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#  post_id     :integer
#
class PostCategory < ApplicationRecord
	belongs_to :post
	belongs_to :category
end
