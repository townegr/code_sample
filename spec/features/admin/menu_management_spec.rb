require 'spec_helper'

feature 'admin manages menus' do
  let(:admin_user) { FactoryGirl.create(:user, role: 'admin') }

  context 'for authorized user' do
    scenario 'to create new menu' do
      recipe = FactoryGirl.create_list(:recipe, 4)
      sign_in_as(admin_user)
      prev_count = Menu.count
      within(:css, '.navbar') do
        click_on 'Admin'
      end
      within(:css, '.navbar') do
        click_on 'Menus'
      end

      expect(current_path).to eq(admin_menus_path)

      click_on 'Add Week'

      expect(current_path).to eq(new_admin_menu_path)

      check('menu_recipe_ids_1')
      check('menu_recipe_ids_2')
      check('menu_recipe_ids_3')
      check('menu_recipe_ids_4')
      click_on 'Create Menu'

      expect(Menu.count).to eq(prev_count + 1)
      expect(current_path).to eq(admin_menus_path)
      expect(page).to have_content('Menu created')
    end
  end
end
