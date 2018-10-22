require 'rails_helper'

RSpec.describe ItemsController, type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET #index" do
    it "should be called Item.list with three args and renders blank array" do
      expect(Item).to receive(:list).with(items_url, 0, 1).once.and_return({ items: [] })
      get items_url, params: { offset: 0, limit: 1 }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:items]).to eq([])
    end
  end

  describe "GET #show" do
    let(:item) { FactoryBot.create(:item, status: :activated, publish_status: :published) }

    context 'when the item is viewable' do
      it "returns item information" do
        get item_url(item.id)
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:name]).to eq(item.name)
        expect(body[:price]).to eq(item.price)
      end
    end

    context 'when the item is not exists' do
      it "returns http status bad request" do
        item.update!(status: :deleted)
        get item_url(item.id)
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:messages]).to eq([I18n.t('api_errors.unviewable_item')])
      end
    end

    context 'when the item is not viewable' do
      it "returns error messages" do
        get item_url(999)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) { { name: 'example', price: 100, publish_status: 'published' } }

      it "creates a new item" do
        expect { post items_url, params: valid_params, headers: authorization(user) }.to change(Item, :count).by(1)
      end

      it "returns created http status" do
        post items_url, params: valid_params, headers: authorization(user)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { name: 'example', price: nil, publish_status: 'published' } }

      it "unsaved new item" do
        expect { post items_url, params: invalid_params, headers: authorization(user) }.not_to change(Item, :count)
      end

      it "returns unprocessable_entity http status with error messages" do
        post items_url, params: invalid_params, headers: authorization(user)
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:messages]).not_to be_nil
      end
    end
  end

  describe "PATCH #update" do
    let(:item) { FactoryBot.create(:item, user: user) }

    context "with valid params" do
      let(:valid_params) { { name: 'new_name', price: 200, publish_status: 'unpublished' } }

      it "update to new values" do
        patch item_url(item.id), params: valid_params, headers: authorization(user)
        expect(response).to have_http_status(:no_content)
        item.reload
        expect(item.name).to eq('new_name')
        expect(item.price).to eq(200)
        expect(item.publish_status).to eq('unpublished')
      end
    end

    context "when the item is not exist" do
      it "returns http status bad request" do
        patch item_url(999), headers: authorization(user)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { name: 'new_name', price: -100, publish_status: 'unpublished' } }

      it "returns unprocessable_entity http status with error messages" do
        patch item_url(item.id), params: invalid_params, headers: authorization(user)
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:messages]).not_to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:item) { FactoryBot.create(:item, user: user, status: :activated) }

    it "update status to deleted" do
      expect { delete item_url(item.id), headers: authorization(user) }.to change {
        item.reload.status
      }.from('activated').to('deleted')
      expect(response).to have_http_status(:no_content)
    end

    context "when the item is not exist" do
      it "returns http status bad request" do
        delete item_url(999), headers: authorization(user)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
