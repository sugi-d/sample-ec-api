FactoryBot.define do
  factory :point do
    amount { 100 }
    kind { :registration }
    association :user, factory: :user
  end
end
