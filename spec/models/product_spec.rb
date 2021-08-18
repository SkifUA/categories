require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:category) { create :category }
  subject { create(:product, category: category) }

  it 'must be invalid' do
    expect(Product.new.valid?).to be_falsey
  end

  it 'must be valid' do
    expect(subject.valid?).to be_truthy
  end

  it 'must be find by category' do
    subject.reload
    expect(Product.by_category(category).take.category_id).to eq category.id
  end

  it 'must be by name order' do
    name1 = 'first'
    name2 = 'second'
    create(:product, name: name1)
    subject.update(name: name2)

    expect(Product.order_by_name.first.name).to eq name1
    expect(Product.order_by_name(:asc).first.name).to eq name1
    expect(Product.order_by_name('asc').first.name).to eq name1
    expect(Product.order_by_name('desc').first.name).to eq name2
    expect(Product.order_by_name(:desc).first.name).to eq name2
  end


end