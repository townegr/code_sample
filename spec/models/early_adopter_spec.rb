# == Schema Information
#
# Table name: early_adopters
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  source     :string(255)
#

require 'spec_helper'

describe EarlyAdopter do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
end
