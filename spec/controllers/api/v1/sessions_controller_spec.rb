require 'rails_helper'

RSpec.describe API::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryGirl.create :user }

    context 'when the credentials are correct' do
      before(:each) do
        credentials = { email: user.email, password: '12345678' }
        post :create, session: credentials
      end

      it 'returns the user record corresponding to the given credentials' do
        user.reload
        expect(json_response[:auth_token]).to eql user.auth_token
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        credentials = { email: user.email, password: 'invalidpassword' }
        post :create, session: credentials
      end

      it 'return a json with an error' do
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end

      it { is_expected.to respond_with 422 }
    end
  end
end