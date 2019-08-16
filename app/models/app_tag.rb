# == Schema Information
#
# Table name: app_tags
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  app_id     :integer
#  tag_id     :integer
#

class AppTag < ApplicationRecord
	belongs_to :app
	belongs_to :tag
end
