require 'spec_helper'

feature 'guest visits TPC' do
  let(:user) { FactoryGirl.build(:user) }
  let(:recipes) { FactoryGirl.create_list(:recipe, 4) }
  let(:menu) { FactoryGirl.create(:menu) }

  context 'for unauthorized user' do
    scenario 'to create an order', js: true do
      recipes.each do |recipe|
        menu.recipes << recipe
      end
      visit root_path
      within(:css, '.navbar') do
        click_on 'Menu'
      end

      expect(current_path).to eq(recipes_path)

      # first('.recipes').find(:css, "order_button_recipe_#{recipes.first.id}").click
      # first('.recipesfi').click('.fa-plus-circle')
      # first('.recipes').first('.fa-plus-circle').click
      # within(:css, ".order-button-recipe-1") do
      first(".order-button-recipe-#{recipes.first.id}") do
        click_on '.fa-plus-circle'
      end

      expect(current_path).to eq(new_user_registration_path)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation
      click_on 'Sign up'

      expect(current_path).to eq(user_path(user))
      expect(page).to have_content("Welcome! You have signed up successfully.")
      expect(page).to have_content(user.email)
      expect(Order.count).to eq(prev_count + 1)
      expect(order.recipes).to eq(recipes.first)
      # within(:css, '.recipes') do
      #   click_on "order_button_recipe_#{recipes.first.id}"
      #   click_on "order_button_recipe_#{recipes.last.id}"
      # end
    end
  end
end
