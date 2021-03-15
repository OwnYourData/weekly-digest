# == Schema Information
#
# Table name: source_reports
#
#  id         :integer          not null, primary key
#  comment    :text
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  source_id  :integer
#  user_id    :integer
#

class SourceReport < ApplicationRecord
	belongs_to :source
	belongs_to :user
	
end
