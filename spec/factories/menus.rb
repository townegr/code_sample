# == Schema Information
#
# Table name: menus
#
#  id         :integer          not null, primary key
#  start_at   :datetime         not null
#  end_at     :datetime         not null
#  created_at :datetime
#  updated_at :datetime
#  status     :string(255)
#

FactoryGirl.define do
  factory :menu do
    sequence(:start_at) { |n| Chronic.parse("last #{Menu::START_DAY} #{Menu::START_TIME}").to_datetime + n.week - 3.week }
    sequence(:end_at) { |n| (Chronic.parse("last #{Menu::START_DAY} #{Menu::START_TIME}")).to_datetime + n.week - 2.week - 1.second }
  end
end
