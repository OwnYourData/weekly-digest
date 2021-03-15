# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  full_name              :string
#  name                   :string
#  password_digest        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  status                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :validatable, :trackable, :rememberable, :registerable, :recoverable and :omniauthable
#    devise :database_authenticatable

    has_many :posts, dependent: :destroy
    has_many :weekly_apps, dependent: :destroy
    has_many :apps, dependent: :destroy
    has_many :sources, dependent: :destroy
    has_many :source_reports, dependent: :destroy

    has_secure_password
end
