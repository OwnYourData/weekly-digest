# == Schema Information
#
# Table name: weekly_internals
#
#  id         :bigint(8)        not null, primary key
#  intro      :text
#  lang       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  weekly_id  :integer
#
class WeeklyInternal < ApplicationRecord
	belongs_to :weekly
end
