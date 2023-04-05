require 'rails_helper'

RSpec.describe ClockOut, type: :model do
  describe 'associations' do
    it { should belong_to(:clock_in) }
  end

  describe 'validations' do
    it { should validate_presence_of(:clock_in) }
  end
end
