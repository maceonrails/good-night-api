FactoryBot.define do
  factory :clock_in do
    user { nil }
  time { Time.zone.now }

    trait :with_clock_out do
      after(:create) do |clock_in|
        create(:clock_out, clock_in: clock_in)
      end
    end
  end
end
