require 'spec_helper'

feature 'admin access' do

  context 'for authorized user' do
    scenario 'displays page without errors' do
      prev_count = User.count
      admin_user = FactoryGirl.create(:user, role: 'admin')
      sign_in_as(admin_user)

      expect(page).to have_content('Signed in successfully.')

      within(:css, '.navbar') do
        click_on 'Admin'
      end

      expect(User.count).to eq(prev_count + 1)
      expect(current_path).to eq(admin_root_path)
    end
  end

  context 'for unauthorized user' do
    scenario 'redirects to root page with error' do
      non_admin_user = FactoryGirl.create(:user)
      sign_in_as(non_admin_user)
      visit admin_root_path

      expect(current_path).to eq(user_path(non_admin_user))
      expect(page).to have_content('You are not authorized to access this page.')
    end
  end
end
