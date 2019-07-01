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
end
