FactoryBot.define do
  factory :player do
    sequence(:username) { |n| "Player#{n}" }
  end
end
