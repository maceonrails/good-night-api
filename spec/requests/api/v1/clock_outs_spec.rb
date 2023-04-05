require 'rails_helper'

RSpec.describe 'Clock Out API', type: :request do
  describe 'POST /api/v1/clock_outs' do
    let(:user) { create(:user) }

    context 'when user is clocked in' do
      let!(:clock_in) { create(:clock_in, user: user) }

      it 'returns 201' do
        post api_v1_clock_outs_path, params: { user_id: user.id }
        expect(response).to have_http_status(:created)
      end

      it 'creates a clock out' do
        expect { post api_v1_clock_outs_path, params: { user_id: user.id } }
          .to change { user.clock_outs.count }.by(1)
      end

      it 'returns all clocked-in times order by created time' do
        clock_in1 = create(:clock_in, :with_clock_out, time: 1.minute.ago, user: user)
        clock_in2 = create(:clock_in, :with_clock_out, time: 3.minutes.ago, user: user)
        clock_in3 = create(:clock_in, :with_clock_out, time: 2.minutes.ago, user: user)

        post api_v1_clock_outs_path, params: { user_id: user.id }

        expect(response.body).to eq([clock_in, clock_in1, clock_in2, clock_in3].to_json)
      end
    end

    context 'when user is not clocked in' do
      it 'returns 422' do
        post api_v1_clock_outs_path, params: { user_id: user.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a clock out' do
        expect { post api_v1_clock_outs_path, params: { user_id: user.id } }
          .not_to(change { user.clock_outs.count })
      end

      it 'returns an error message' do
        post api_v1_clock_outs_path, params: { user_id: user.id }
        expect(response.body).to eq({ message: 'Please clock in first.' }.to_json)
      end
    end
  end
end