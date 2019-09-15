# == Schema Information
#
# Table name: source_tools
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  app_id     :integer
#  source_id  :integer
#

class SourceTool < ApplicationRecord
	belongs_to :source
	belongs_to :app
end
