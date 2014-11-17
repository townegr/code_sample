# == Schema Information
#
# Table name: social_links
#
#  id          :integer          not null, primary key
#  chef_id     :integer
#  social_type :string(255)      not null
#  url         :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe SocialLink do
  it { should belong_to(:chef) }
end
