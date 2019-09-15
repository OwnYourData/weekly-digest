# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  full_name  :string
#  name       :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
	has_many :posts, dependent: :destroy
	has_many :weekly_apps, dependent: :destroy
	has_many :apps, dependent: :destroy
	has_many :sources, dependent: :destroy
	has_many :source_reports, dependent: :destroy

end
