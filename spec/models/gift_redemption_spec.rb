# == Schema Information
#
# Table name: gift_redemptions
#
#  id               :integer          not null, primary key
#  gift_purchase_id :integer
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  token            :string(255)
#

require 'spec_helper'

describe GiftRedemption do
  it { should belong_to(:gift_purchase) }
end
