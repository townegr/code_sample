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

require 'spec_helper'

describe Instruction do
  it { should belong_to(:recipe).inverse_of(:instructions) }

  it { should validate_uniqueness_of(:step_number).scoped_to(:recipe_id) }
  it { should validate_presence_of(:step_number) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:recipe) }
end
