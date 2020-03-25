FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "#{n}_first_name" }
    sequence(:last_name) { |n| "#{n}_last_name" }
    sequence(:email) { |n| "#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end