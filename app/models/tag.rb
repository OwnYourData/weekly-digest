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
end
