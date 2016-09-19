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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
