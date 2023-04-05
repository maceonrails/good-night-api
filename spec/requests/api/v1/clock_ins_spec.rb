require 'rails_helper'

RSpec.describe 'Clock In API', type: :request do
  describe 'POST /api/v1/clock_ins' do
    let(:user) { create(:user) }

    context 'when user is not clocked in' do
      it 'returns 201' do
        post api_v1_clock_ins_path, params: { user_id: user.id }
        expect(response).to have_http_status(:created)
      end

      it 'creates a clock in' do
        expect { post api_v1_clock_ins_path, params: { user_id: user.id } }
          .to change { user.clock_ins.count }.by(1)
      end

      it 'returns the past week of clock ins' do
        post api_v1_clock_ins_path, params: { user_id: user.id }
        expect(response.body).to eq(user.clocked_in_past_week.to_json)
      end
    end

    context 'when user is already clocked in' do
      before { create(:clock_in, user: user) }

      it 'returns 422' do
        post api_v1_clock_ins_path, params: { user_id: user.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a clock in' do
        expect { post api_v1_clock_ins_path, params: { user_id: user.id } }
          .not_to(change { user.clock_ins.count })
      end

      it 'returns an error message' do
        post api_v1_clock_ins_path, params: { user_id: user.id }
        expect(response.body).to eq({ message: 'Please clock out first.' }.to_json)
      end
    end
  end
end