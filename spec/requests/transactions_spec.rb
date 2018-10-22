require 'rails_helper'

RSpec.describe TransactionsController, type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:item) { FactoryBot.create(:item) }

  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) { { item_id: item.id } }

      it "should be called Transaction.buy! with current_user.id and item.id" do
        expect(Transaction).to receive(:buy!).with(user.id, item.id)
        post transactions_url, params: valid_params, headers: authorization(user)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      context 'when the item is not exists'do
        it "returns bad_request http status" do
          post transactions_url, params: { item_id: 999 }, headers: authorization(user)
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when raise error' do
        it "returns unprocessable_entity http status with error messages" do
          allow(Transaction).to receive(:buy!).and_raise(StandardError.new('test'))
          post transactions_url, params: { item_id: item.id }, headers: authorization(user)
          expect(response).to have_http_status(:unprocessable_entity)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages]).to eq(['test'])
        end
      end
    end
  end
end
