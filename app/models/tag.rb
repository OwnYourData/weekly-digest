# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        not null, primary key
#  status     :integer
#  tag        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ApplicationRecord
	has_many :posting_tags, dependent: :destroy
	has_many :app_tags, dependent: :destroy
end
