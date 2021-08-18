require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { create(:category) }

  it 'must be invalid' do
    expect(Category.new.valid?).to be_falsey
  end

  it 'must be valid' do
    expect(subject.valid?).to be_truthy
  end

  it 'must be include each child ids' do
    child1 = create(:category, parent_id: subject.id)
    child2 = create(:category, parent_id: subject.id)
    child3 = create(:category, parent_id: child2.id)
    child4 = create(:category, parent_id: child3.id)
    child5 = create(:category, parent_id: child4.id)
    expect(subject.family_ids).to include(subject.id, child1.id, child2.id, child3.id, child4.id, child5.id)
    expect(subject.family_ids.count).to eq 6
  end
end