# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  category      :string
#  category_type :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Category < ApplicationRecord
	has_many :post_categories, dependent: :destroy
	has_many :app_categories, dependent: :destroy
end
