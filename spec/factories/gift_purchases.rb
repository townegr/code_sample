# == Schema Information
#
# Table name: gift_purchases
#
#  id              :integer          not null, primary key
#  gift_id         :integer
#  purchaser_email :string(255)
#  purchaser_name  :string(255)
#  gift_message    :text
#  send_at         :datetime
#  recipient_email :string(255)
#  recipient_name  :string(255)
#  value           :decimal(5, 2)    not null
#  token           :string(255)
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  stripe_token    :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gift_purchase do
    gift_id 1
    purchaser_email "john@example.com"
    purchaser_name "John Doe"
    gift_message nil
    send_at "2014-08-14 00:04:40"
    recipient_email "jane@example.com"
    recipient_name "Jane Doe"
    value { BigDecimal('59') }
    token nil
    status nil
  end
end
