# == Schema Information
#
# Table name: gifts
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text
#  value       :decimal(5, 2)    not null
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Gift do
  it { should have_many(:gift_purchases) }
end
