# == Schema Information
#
# Table name: statistics
#
#  id         :integer          not null, primary key
#  lang       :string
#  source     :string
#  target     :string
#  timestamp  :integer
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :string
#  source_id  :integer
#  target_id  :integer
#
class Statistic < ApplicationRecord
end
