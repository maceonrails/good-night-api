require 'rails_helper'

RSpec.describe ClockIn, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one(:clock_out) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
  end

  describe 'scopes' do
    let!(:user) { create(:user) }

    describe '.clocked_in' do
      let!(:clock_in) { create(:clock_in, user: user) }

      it 'returns clocked in records' do
        expect(ClockIn.clocked_in).to eq([clock_in])
      end

      context 'when clocked out' do
        let!(:clock_out) { create(:clock_out, clock_in: clock_in) }

        it 'does not return clocked in records' do
          expect(ClockIn.clocked_in).to eq([])
        end
      end
    end

    describe '.clocked_out' do
      let!(:clock_in) { create(:clock_in, user: user) }

      it 'does not return clocked out records' do
        expect(ClockIn.clocked_out).to eq([])
      end

      context 'when clocked out' do
        let!(:clock_out) { create(:clock_out, clock_in: clock_in) }

        it 'returns clocked out records' do
          expect(ClockIn.clocked_out).to eq([clock_in])
        end
      end
    end
  end
end
