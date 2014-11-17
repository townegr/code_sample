# == Schema Information
#
# Table name: ingredients
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  recipe_id  :integer
#

require 'spec_helper'

describe Ingredient do
  it { should belong_to(:recipe) }

  it { should validate_presence_of(:name) }
end
