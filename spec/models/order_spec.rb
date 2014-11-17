# == Schema Information
#
# Table name: orders
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  menu_id                  :integer
#  created_at               :datetime
#  updated_at               :datetime
#  status                   :string(255)
#  tracking_number          :string(255)
#  price                    :decimal(5, 2)
#  amount_charged           :decimal(5, 2)
#  shipping_label           :string(255)
#  shipping_tracking_number :string(255)
#  order_number             :integer
#  coupon_id                :integer
#  coupon_code              :string(255)
#

require 'spec_helper'
require 'fedex/shipment'

describe Order do
  it { should belong_to(:user) }
  it { should belong_to(:menu) }
  it { should have_and_belong_to_many(:recipes) }

  let(:recipe) { FactoryGirl.create(:recipe) }
  let(:order) { FactoryGirl.create(:order) }

  describe "#exceeds_order_capacity?" do
    it "returns true if order reaches full capacity" do
      order.recipes << FactoryGirl.create_list(:recipe, 2)

      expect(order.exceeds_order_capacity?).to eq(true)
    end

    it "returns false if order has not reached full capacity" do
      order.recipes << FactoryGirl.create_list(:recipe, 1)

      expect(order.exceeds_order_capacity?).to eq(false)
    end
  end

  describe "#includes_recipe?" do
    it "returns true if order contains recipe" do
      order.recipes << recipe

      expect(order.includes_recipe?(recipe)).to eq(true)
    end

    it "returns false if order does not contain recipe" do
      order.recipes << FactoryGirl.create(:recipe)

      expect(order.includes_recipe?(recipe)).to eq(false)
    end
  end

  describe "#current_week_recipe?" do
    before do
      FactoryGirl.reload
    end

    let(:menus) { FactoryGirl.create_list(:menu, 4) }
    let(:recipes_this_week) { FactoryGirl.create_list(:recipe, 4) }
    let(:recipes_next_week) { FactoryGirl.create_list(:recipe, 4) }
    let(:order) { FactoryGirl.create(:order, menu: menus.first) }

    it "returns true if current week includes recipe" do
      menus.third.recipes << recipes_this_week
      menus.last.recipes << recipes_next_week
      current_recipe = recipes_this_week.first

      expect(order.current_week_recipe?(current_recipe)).to eq(true)
    end

    it "returns false if current week does not include recipe" do
      menus.third.recipes << recipes_this_week
      menus.last.recipes << recipes_next_week
      noncurrent_recipe = recipes_next_week.first

      expect(order.current_week_recipe?(noncurrent_recipe)).to eq(false)
    end
  end

  describe "#build_or_block_new_order" do
    before do
      FactoryGirl.reload
    end

    let(:new_recipe) { FactoryGirl.create(:recipe) }
    let(:menus) { FactoryGirl.create_list(:menu, 4) }
    let(:recipes_this_week) { FactoryGirl.create_list(:recipe, 4) }
    let(:recipes_next_week) { FactoryGirl.create_list(:recipe, 4) }
    let(:order) { FactoryGirl.create(:order, menu: menus.first) }

    it "adds new recipe to order when all 3 conditions are met" do
      # three (3) conditions are the following:
      #  i)   does not exceed order capacity
      #  ii)  order does not include equivalent recipe
      #  iii) curent week includes respective recipe

      order.recipes << FactoryGirl.create_list(:recipe, 1)
      prev_count = order.recipes.count
      menus.third.recipes << new_recipe
      updated_order = order.build_or_block_new_order(new_recipe)

      expect(updated_order.count).to eq(prev_count + 1)
      expect(updated_order.last).to eq(new_recipe)
    end

    it "prevents adding new recipe to order when order reaches capacity" do
      order.recipes << FactoryGirl.create_list(:recipe, 2)
      prev_count = order.recipes.count
      menus.third.recipes << new_recipe
      updated_order = order.build_or_block_new_order(new_recipe)

      expect(updated_order).to eq(nil)
      order.recipes.each do |recipe|
        expect(recipe).not_to eq(new_recipe)
      end
      expect(Order.first.recipes.count).to eq(prev_count)
    end

    it "prevents adding new recipe to order when order includes equivalent recipe" do
      order.recipes << FactoryGirl.create_list(:recipe, 1)
      duplicate_recipe = Recipe.find(1)
      prev_count = order.recipes.count
      updated_order = order.build_or_block_new_order(duplicate_recipe)

      expect(updated_order).to eq(nil)
      expect(order.recipes.first).to eq(duplicate_recipe)
      expect(Order.first.recipes.count).to eq(prev_count)
    end

    it "prevents adding new recipe to order when current week does not include respective recipe" do
      menus.third.recipes << recipes_this_week
      menus.last.recipes << recipes_next_week
      noncurrent_recipe = recipes_next_week.first
      prev_count = order.recipes.count
      updated_order = order.build_or_block_new_order(noncurrent_recipe)

      expect(updated_order).to eq(nil)
      recipes_this_week.each do |recipe|
        expect(recipe).not_to eq(noncurrent_recipe)
      end
      expect(Order.first.recipes.count).to eq(prev_count)
    end
  end

  describe '#process_coupon_code' do
    it 'discounts the order price by the value of the coupon if a coupon code is provided' do
      coupon = FactoryGirl.create(:coupon, dollar_off: nil)
      user = FactoryGirl.create(:user)
      order.coupon_code = coupon.code
      original_order_price = order.price
      discounted_order_price = original_order_price - (original_order_price * coupon.percentage_off / 100)
      discounted_order = order.process_coupon_code

      expect(discounted_order).not_to raise_error
      expect(order.price).to eq(discounted_order_price)
    end
  end

  describe '#charge_card' do
    before { StripeMock.start }
    after { StripeMock.stop }

    it "charges customer's debit/credit card via Stripe" do
      user = FactoryGirl.create(:user)
      order.user_id = user.id
      successful_purchase = order.charge_card

      expect(successful_purchase).not_to raise_error
      expect(order.status).to eq("Successful charge")
    end

    it "returns an error via Stripe if debit/credit card is declined" do
      StripeMock.prepare_card_error(:card_declined, :new_charge)
      user = FactoryGirl.create(:user)
      order.user_id = user.id
      failed_purchase = order.charge_card

      expect(failed_purchase).not_to raise_error
      expect(order.status).to eq("Charge error")
    end
  end

  # describe '#create_shipment' do
  #   # let(:fedex) { Fedex::Shipment.new(fedex_credentials) }
  #   it 'creates a shipping label with address and tracking number', :vcr do
  #     VCR.use_cassette "shipment/label" do
  #       user = FactoryGirl.create(:user)
  #       order.user_id = user.id
  #       successful_shipment = order.create_shipment

  #       expect(successful_shipment).not_to raise_error
  #     end
  #   end
  # end
end

