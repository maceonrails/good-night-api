FactoryBot.define do
  factory :user do
    name { 'John Doe' }

    trait :with_sleep_records do
      after(:create) do |user|
        create_list(:sleep_record, 3, user: user)
      end
    end
  end
end
