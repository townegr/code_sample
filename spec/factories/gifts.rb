# == Schema Information
#
# Table name: gifts
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text
#  value       :decimal(5, 2)    not null
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gift do
    name "MyString"
    description "MyText"
    value "9.99"
    image "MyString"
  end
end
