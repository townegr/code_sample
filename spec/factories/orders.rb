# == Schema Information
#
# Table name: orders
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  menu_id                  :integer
#  created_at               :datetime
#  updated_at               :datetime
#  status                   :string(255)
#  tracking_number          :string(255)
#  price                    :decimal(5, 2)
#  amount_charged           :decimal(5, 2)
#  shipping_label           :string(255)
#  shipping_tracking_number :string(255)
#  order_number             :integer
#  coupon_id                :integer
#  coupon_code              :string(255)
#

FactoryGirl.define do
  factory :order do
    user nil
    menu nil
    tracking_number nil
    price "59.0"
    amount_charged "44.0"
    shipping_label nil
    shipping_tracking_number nil
    order_number nil
    coupon_id nil
    coupon_code nil
  end
end
