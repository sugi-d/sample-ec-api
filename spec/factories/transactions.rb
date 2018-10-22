FactoryBot.define do
  factory :transaction do
    price { 100 }
    association :user, factory: :user
    association :item, factory: :item
  end
end
