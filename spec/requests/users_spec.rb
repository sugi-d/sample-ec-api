require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) { { email: 'a@example.com', password: '123456', password_confirmation: '123456' } }

      it "creates a new user" do
        expect { post users_url, params: valid_params }.to change(User, :count).by(1)
      end

      it "returns no content http status" do
        post users_url, params: valid_params
        expect(response).to have_http_status(:no_content)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { email: 'a@example.com', password: '123456', password_confirmation: '23456' } }

      it "unsaved new user" do
        expect { post users_url, params: invalid_params }.not_to change(User, :count)
      end

      it "returns unprocessable_entity http status with error messages" do
        post users_url, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:messages]).not_to be_nil
      end
    end
  end
end
