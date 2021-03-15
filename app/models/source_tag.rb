# == Schema Information
#
# Table name: source_tags
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  source_id  :integer
#  tag_id     :integer
#

class SourceTag < ApplicationRecord
	belongs_to :source
	belongs_to :tag
end
