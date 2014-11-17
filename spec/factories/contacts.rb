# == Schema Information
#
# Table name: contacts
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  email        :string(255)
#  contact_type :string(255)
#  body         :text
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    name "MyString"
    email "MyString"
    contact_type "MyString"
    body "MyText"
  end
end
