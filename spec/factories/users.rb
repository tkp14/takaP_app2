FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    activated { true }
    activated_at { Time.zone.now }
    #introduction { "はじめまして。料理初心者ですが、頑張ります！" }
    #sex { "男性" }

    trait :admin do
      admin { true }
    end

    trait :no_activated do
      activated { false }
      activated_at { nil }
    end
  end
end
