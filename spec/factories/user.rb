FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com"}
    first_name "David"
    last_name "Ortiz"
    address "4 Yawkey Way"
    city "Boston"
    state "MA"
    zip "02215"
    country "US"
    password "qwertyqwerty"
    password_confirmation "qwertyqwerty"
    role 'member'
    stripe_customer_id nil

    factory :user_with_menus do
      after(:create) do |user|
        menus = FactoryGirl.create_list(:menu, 4)
        user.orders << [
          FactoryGirl.create(:order, menu: menus.second),
          FactoryGirl.create(:order, menu: menus.third)
        ]
      end
    end
  end
end
