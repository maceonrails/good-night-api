require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:clock_ins) }
    it { should have_many(:clock_outs).through(:clock_ins) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
