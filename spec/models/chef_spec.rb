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

require 'spec_helper'

describe Chef do
  it { should have_many(:recipes) }
  it { should have_many(:social_links) }
  it { should accept_nested_attributes_for(:social_links) }

  it { should validate_presence_of(:name) }

  describe "#hometown" do
    it "returns city and state in standard format" do
      chef = FactoryGirl.create(:chef)

      expect(chef.hometown).to eq("Chicago, IL")
    end
  end
end
