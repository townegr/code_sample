# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string(255)      default(""), not null
#  encrypted_password       :string(255)      default(""), not null
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  role                     :string(255)
#  image                    :string(255)
#  first_name               :string(255)
#  last_name                :string(255)
#  address                  :string(255)
#  address2                 :string(255)
#  city                     :string(255)
#  state                    :string(255)
#  zip                      :string(255)
#  country                  :string(255)
#  stripe_customer_id       :string(255)
#  stripe_cc_last_four      :integer
#  stripe_cc_type           :string(255)
#  stripe_cc_exp_month      :integer
#  stripe_cc_exp_year       :integer
#  stripe_token             :string(255)
#  credit                   :decimal(5, 2)    default(0.0), not null
#  is_residential           :boolean          default(TRUE)
#  is_blocked_from_ordering :boolean          default(FALSE)
#  phone                    :string(255)
#  account_number           :integer
#

require 'spec_helper'

describe User do
  it { should have_many(:orders) }
  it { should have_many(:recipes).through(:orders) }

  describe "#current_order" do
    before do
      FactoryGirl.reload
    end

    it "returns this week's order for current user if order exists" do
      user = FactoryGirl.create(:user_with_menus)
      order = user.orders.second
      current_order = user.current_order

      expect(current_order).to eq(order)
      expect(Menu.this_week).to eq(current_order.menu)
    end

    it "returns nothing if an order does not exist" do
      user = FactoryGirl.create(:user)
      current_order = user.current_order

      expect(current_order).to be_empty
    end
  end
end
