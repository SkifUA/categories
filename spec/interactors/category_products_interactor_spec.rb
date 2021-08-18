require 'rails_helper'

RSpec.describe CategoryProductsInteractor, type: :interactor do
  let(:category)    { create(:category) }

  describe 'run validation' do
    it 'must be failure with empty params' do
      expect { subject.validation }.to raise_error(Interactor::Failure)
    end

    it 'must be failure without params[:id]' do
      allow(subject).to receive(:context).and_return(
        Interactor::Context.build(
          params: {}
        )
      )
      expect { subject.validation }.to raise_error(Interactor::Failure)
    end

    it 'must be failure with incorrect params[:id]' do
      allow(subject).to receive(:context).and_return(
        Interactor::Context.build(
          params: { id: 0 }
        )
      )
      expect { subject.validation }.to raise_error(Interactor::Failure)
    end

    it 'must be correct creating addon with correct params[:id]' do
      allow(subject).to receive(:context).and_return(
        Interactor::Context.build(
          params: { id: category.id }
        )
      )
      subject.validation
      expect(subject.context).to be_a_success
      expect(subject.context.success?).to be_truthy
    end
  end
end