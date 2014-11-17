# == Schema Information
#
# Table name: chefs
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  image       :string(255)
#  biography   :text
#  created_at  :datetime
#  updated_at  :datetime
#  specialties :text
#  restaurants :text
#  city        :string(255)
#  state       :string(255)
#  cookbooks   :text
#

FactoryGirl.define do
  factory :chef do
    name 'Chef David Chang'
    image Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/support/images/chef_image.jpeg')))
    biography 'David Chang is a Korean-American chef and entrepreneur.'
    city 'chicago'
    state 'il'
  end
end
