require 'spec_helper'

feature 'admin manages recipes' do
  let(:admin_user) { FactoryGirl.create(:user, role: 'admin') }

  context 'for authorized user' do
    scenario 'to create new recipe' do
      prev_count = Recipe.count
      FactoryGirl.create(:chef)
      recipe = FactoryGirl.build(:recipe)
      instruction = FactoryGirl.build(:instruction)
      sign_in_as(admin_user)
      within(:css, '.navbar') do
        click_on 'Admin'
      end
      within(:css, '.navbar') do
        click_on 'Recipes'
      end

      expect(current_path).to eq(admin_recipes_path)

      click_on 'Add Recipe'

      expect(current_path).to eq(new_admin_recipe_path)

      fill_in 'Title', with: recipe.title
      fill_in 'Description', with: recipe.description
      select recipe.chef.name, from: 'Chef'
      fill_in 'Servings', with: recipe.servings
      fill_in 'Calories', with: recipe.calories
      fill_in 'Carbohydrates', with: recipe.carbs
      fill_in 'Fat', with: recipe.fat
      fill_in 'Protein', with: recipe.protein
      within(:css, '.recipe_image') do
        attach_file('recipe_image', File.join(Rails.root, '/spec/support/images/stir_fry.jpg'))
      end
      within(:css, '.instructions') do
        page.find(:css, "select").select(instruction.step_number)
        fill_in 'recipe_instructions_attributes_0_title', with: instruction.title
        fill_in 'recipe_instructions_attributes_0_description', with: instruction.description
      end
      attach_file('Image', File.join(Rails.root, '/spec/support/images/stir_fry.jpg'))
      click_on 'Create Recipe'

      expect(Recipe.count).to eq(prev_count + 1)
      expect(current_path).to eq(admin_recipes_path)
      expect(page).to have_content('Recipe created')
    end
  end
end
