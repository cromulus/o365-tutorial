# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string
#  oauth_token   :string
#  token         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  refresh_token :string
#

class User < ActiveRecord::Base
  has_secure_token
end
