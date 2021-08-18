FactoryBot.define do
  factory :category, class: 'Category' do
    name { Faker::Company.name }
  end
end
