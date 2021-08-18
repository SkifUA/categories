FactoryBot.define do
  factory :product, class: 'Product' do
    name { Faker::Company.name }
    association :category, factory: :category
  end
end
