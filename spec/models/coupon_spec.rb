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

require 'spec_helper'

describe Coupon do
  describe "#display_discount" do

    it "returns the discount as a percentage if percentage is provided" do
      coupon = FactoryGirl.create(:coupon)

      expect(coupon.display_discount).to eq("25%")
    end

    it "returns the discount as a dollar figure if dollar is provided" do
      coupon = FactoryGirl.create(:coupon, percentage_off: nil)

      expect(coupon.display_discount).to eq("$25.00")
    end
  end
end
