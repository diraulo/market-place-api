require 'rails_helper'
require 'pry-byebug'
RSpec.describe API::V1::UsersController, type: :controller do
  before(:each) { request.headers['Accept'] = 'application/vnd.marketplace.v1' }

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { is_expected.to respond_with 200 }
  end

  describe 'POST #create' do
    context 'user is successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it 'renders the json representation for the created user record' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { is_expected.to respond_with 201 }
    end

    context 'user is not created' do
      before(:each) do
        @invalid_user_attributes = { password: '12345678',
                                     password_confirmation: '12345678' }
        post :create, { user: @invalid_user_attributes }, format: :json
      end

      it 'renders a json error' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key :errors
      end

      it 'renders the json errors with reason user could not be created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe 'PUT/PATCH #create' do
    context 'user is successfully updated' do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id,
                         user: { email: 'newmail@example.com' } }, format: :json
        # binding.pry
      end

      it 'renders the json representation for the updated user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql 'newmail@example.com'
      end

      it { is_expected.to respond_with 200 }
    end

    context 'user is not updated' do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id,
                         user: { email: 'bademail.com' } }, format: :json
      end

      it 'renders a json error' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key :errors
      end

      it 'renders the json errors with reason user could not be created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include 'is invalid'
      end

      it { is_expected.to respond_with 422 }
    end
  end
end
