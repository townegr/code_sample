# == Schema Information
#
# Table name: prep_needs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  recipe_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :prep_need do
    name "MyString"
    references ""
  end
end
