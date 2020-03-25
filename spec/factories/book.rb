FactoryBot.define do
  factory :book do
    sequence(:name) { |n| "#{n}_name" }
  end
end