# == Schema Information
#
# Table name: weekly_internals
#
#  id          :integer          not null, primary key
#  intro       :text
#  lang        :string
#  locale_only :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  weekly_id   :integer
#
class WeeklyInternal < ApplicationRecord
	belongs_to :weekly
end
