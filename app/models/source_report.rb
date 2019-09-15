# == Schema Information
#
# Table name: source_reports
#
#  id         :bigint(8)        not null, primary key
#  comment    :text
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class SourceReport < ApplicationRecord
	belongs_to :source
	belongs_to :user
	
end
