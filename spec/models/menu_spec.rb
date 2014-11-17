# == Schema Information
#
# Table name: menus
#
#  id         :integer          not null, primary key
#  start_at   :datetime         not null
#  end_at     :datetime         not null
#  created_at :datetime
#  updated_at :datetime
#  status     :string(255)
#

require 'spec_helper'

describe Menu do
  it { should have_many(:recipes).through(:menu_items) }
  it { should have_many(:menu_items) }
  it { should have_many(:orders) }
  it { should accept_nested_attributes_for(:menu_items) }

  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }

  before do
    FactoryGirl.reload
  end

  let(:menus) { FactoryGirl.create_list(:menu, 4) }

  describe '#maximum_recipes_per_menu custom validation' do
    it 'should have a valid menu within MAX_RECIPES parameters' do
      Menu::MAX_RECIPES.times { FactoryGirl.create(:recipe) }
      menu = menus.first
      Recipe.all.each { |recipe| menu.recipes << recipe }

      menu.should be_valid
    end

    it 'should not have a valid menu outside MAX_RECIPES parameters' do
      (Menu::MAX_RECIPES + 1).times { FactoryGirl.create(:recipe) }
      menu = menus.first
      Recipe.all.each { |recipe| menu.recipes << recipe }

      menu.should_not be_valid
    end
  end

  describe '#self.this_week' do
    it 'should return current week menu relevant to {Time.now}' do
      this_week_menu = menus.third

      expect(Menu.this_week).to eq(this_week_menu)
    end

    it 'should create a new menu object if a current menu does not exist' do
      this_week_menu = menus.third
      Menu.delete(this_week_menu)

      expect(Menu.all).not_to include(this_week_menu)
      expect(Menu.this_week).to be_new_record
    end
  end

  describe '#self.next_week' do
    it "should return next week's menu" do
      next_week_menu = menus.last

      expect(Menu.next_week).to eq(next_week_menu)
    end

    it "should return nothing if next week's menu does not exist" do
      next_week_menu = menus.last
      Menu.delete(next_week_menu)

      expect(Menu.all).not_to include(next_week_menu)
      expect(Menu.next_week).to eq(nil)
    end
  end

  describe '#self.weeks_ago(number)' do
    it "should return the menu from 2 weeks ago" do
      two_weeks_ago = menus.first

      expect(Menu.weeks_ago(2)).to eq(two_weeks_ago)
    end

    it "should create a new menu object if menu from 2 weeks ago does not exist" do
      two_weeks_ago = menus.first
      Menu.delete(two_weeks_ago)

      expect(Menu.all).not_to include(two_weeks_ago)
      expect(Menu.weeks_ago(2)).to be_new_record
    end
  end
end
