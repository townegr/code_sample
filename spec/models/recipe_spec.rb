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

require 'spec_helper'

describe Recipe do
  it { should have_many(:instructions).inverse_of(:recipe) }
  it { should have_many(:ingredients) }
  it { should have_many(:menu_items) }
  it { should have_many(:menus).through(:menu_items) }
  it { should have_many(:prep_needs) }
  it { should have_and_belong_to_many(:health_benefits) }
  it { should have_and_belong_to_many(:orders) }
  it { should belong_to(:chef) }
  it { should accept_nested_attributes_for(:ingredients) }
  it { should accept_nested_attributes_for(:instructions) }
  it { should accept_nested_attributes_for(:prep_needs) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:image) }
  it { should validate_numericality_of(:calories).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:servings).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:carbs).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:fat).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:protein).is_greater_than_or_equal_to(0) }
end
