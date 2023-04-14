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

    describe '.order_by_sleep_duration' do
      let!(:clock_in) { create(:clock_in, user: user) }
      let!(:clock_out) { create(:clock_out, clock_in: clock_in, time: clock_in.time + 5.hour) }
      let!(:clock_in2) { create(:clock_in, user: user) }
      let!(:clock_out2) { create(:clock_out, clock_in: clock_in2, time: clock_in2.time + 7.hour) }

      it 'orders by sleep duration' do
        expect(ClockIn.order_by_sleep_duration).to eq([clock_in2, clock_in])
      end
    end

    describe '.friends_previous_week_sleep_records' do
      let!(:friend) { create(:user) }
      let!(:friend2) { create(:user) }
      let!(:friendship) { create(:friendship, user: user, friend: friend) }
      let!(:friendship2) { create(:friendship, user: user, friend: friend2) }
      let!(:clock_in) { create(:clock_in, :with_clock_out, user: friend, time: 1.week.ago) }
      let!(:clock_in2) { create(:clock_in, :with_clock_out, user: friend2, time: 1.week.ago) }
      let!(:clock_in3) { create(:clock_in, :with_clock_out, user: friend, time: 2.weeks.ago) }

      it 'returns all friends previous week sleep records' do
        expect(ClockIn.friends_previous_week_sleep_records(user)).to eq([clock_in, clock_in2])
      end
    end
  end
end
