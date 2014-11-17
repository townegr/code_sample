# == Schema Information
#
# Table name: social_links
#
#  id          :integer          not null, primary key
#  chef_id     :integer
#  social_type :string(255)      not null
#  url         :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :social_link do
    chef nil
    social_type "MyString"
    url "MyString"
  end
end
