FactoryBot.define do
  factory :item do
    name { 'string' }
    price { 100 }
    publish_status { :published }
    status { :activated }
    association :user, factory: :user
  end
end
