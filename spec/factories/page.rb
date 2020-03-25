FactoryBot.define do
  factory :page do
    transient do
      content_format { }
    end

    trait :with_html_content do
      after(:create) do |page, evaluator|
        create(:content, page: page, content_format: evaluator.content_format || create(:content_format))
      end
    end
  end
end