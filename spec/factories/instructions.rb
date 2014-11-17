# == Schema Information
#
# Table name: instructions
#
#  id          :integer          not null, primary key
#  recipe_id   :integer          not null
#  step_number :integer          not null
#  image       :string(255)
#  title       :string(255)
#  description :text             not null
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instruction do
    recipe_id 1
    step_number 1
    image "MyString"
    title "Preheat the oven"
    description "Set the oven to 450 degrees fahrenheit"
  end
end
