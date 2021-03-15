# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  confirmed  :boolean
#  email      :string
#  key        :string
#  lang       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Subscription < ApplicationRecord
end
