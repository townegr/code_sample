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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gift_redemption do
    gift_purchase_id 1
    user_id 1
  end
end
