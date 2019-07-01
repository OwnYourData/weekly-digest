# == Schema Information
#
# Table name: posting_tags
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  tag_id     :integer
#

class PostingTag < ApplicationRecord
	belongs_to :post
end
