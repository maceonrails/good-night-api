require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:clock_ins) }
    it { should have_many(:clock_outs).through(:clock_ins) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#clock_in!' do
    let(:user) { create(:user) }

    context 'when user is not clocked in' do
      before do
        create(:clock_in, user: user)
        create(:clock_out, clock_in: user.clock_ins.first)
      end

      it 'returns true' do
        expect(user.clock_in!).to be_truthy
      end

      it 'creates a clock in' do
        expect { user.clock_in! }.to change { user.clock_ins.count }.by(1)
      end
    end

    context 'when user is already clocked in' do
      before { create(:clock_in, user: user) }

      it 'returns false' do
        expect(user.clock_in!).to be_falsey
      end

      it 'does not create a clock in' do
        expect { user.clock_in! }.not_to(change { user.clock_ins.count })
      end
    end
  end

  describe '#clock_out!' do
    let(:user) { create(:user) }

    context 'when user is clocked in' do
      before { create(:clock_in, user: user) }

      it 'returns true' do
        expect(user.clock_out!).to be_truthy
      end

      it 'creates a clock out' do
        expect { user.clock_out! }.to change { user.clock_outs.count }.by(1)
      end
    end

    context 'when user is not clocked in' do
      it 'returns false' do
        expect(user.clock_out!).to be_falsey
      end

      it 'does not create a clock out' do
        expect { user.clock_out! }.not_to(change { user.clock_outs.count })
      end
    end
  end
end
