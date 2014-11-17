require 'spec_helper'

feature 'admin manages chefs' do
  let(:admin_user) { FactoryGirl.create(:user, role: 'admin') }

  context 'for authorized user' do
    scenario 'to create new chef' do
      prev_count = Chef.count
      chef = FactoryGirl.build(:chef)
      sign_in_as(admin_user)
      within(:css, '.navbar') do
        click_on 'Admin'
      end
      within(:css, '.navbar') do
        click_on 'Chefs'
      end

      expect(current_path).to eq(admin_chefs_path)

      click_on 'Add Chef'

      expect(current_path).to eq(new_admin_chef_path)

      fill_in 'Name', with: chef.name
      fill_in 'Biography', with: chef.biography
      attach_file('Image', File.join(Rails.root, '/spec/support/images/chef_image.jpeg'))
      click_on 'Create Chef'

      expect(Chef.count).to eq(prev_count + 1)
      expect(current_path).to eq(admin_chefs_path)
      expect(page).to have_content('Chef added')
    end
  end
end
