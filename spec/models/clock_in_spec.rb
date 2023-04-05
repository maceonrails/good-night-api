require 'rails_helper'

RSpec.describe ClockIn, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one(:clock_out) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
  end
end
