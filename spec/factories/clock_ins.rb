FactoryBot.define do
  factory :clock_in do
    user { nil }

    trait :with_clock_out do
      after(:create) do |clock_in|
        create(:clock_out, clock_in: clock_in)
      end
    end
  end
end
