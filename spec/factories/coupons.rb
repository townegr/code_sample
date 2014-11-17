# == Schema Information
#
# Table name: coupons
#
#  id             :integer          not null, primary key
#  code           :string(255)
#  start_at       :datetime
#  expire_at      :datetime
#  status         :string(255)
#  percentage_off :integer
#  dollar_off     :decimal(5, 2)
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    code "12345"
    start_at Time.now
    expire_at Time.now + 1.year
    status "Active"
    percentage_off 25
    dollar_off "25.00"
  end
end
