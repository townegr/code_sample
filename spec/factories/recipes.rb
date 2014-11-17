# == Schema Information
#
# Table name: recipes
#
#  id                :integer          not null, primary key
#  title             :string(255)      not null
#  description       :text             not null
#  image             :string(255)      not null
#  calories          :integer
#  difficulty        :string(255)
#  chef_id           :integer
#  servings          :integer
#  created_at        :datetime
#  updated_at        :datetime
#  carbs             :integer
#  fat               :integer
#  protein           :integer
#  ingredients_image :string(255)
#  featured_image    :string(255)
#  prep_time         :string(255)
#

FactoryGirl.define do
  factory :recipe do
    sequence(:title) { |n| "Vegetable Stir Fry #{n}" }
    description "Stir-fry an assortment of vegetables"
    image Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/support/images/stir_fry.jpg')))
    calories 350
    difficulty "Easy"
    chef_id 1
    servings 1
    carbs 55
    fat 19
    protein 22
  end
end
