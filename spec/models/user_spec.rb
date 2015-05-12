require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  describe 'Fixtures' do
    it 'should have valid Fixtures Factory' do
      expect(FactoryGirl.create(:user)).to be_valid
    end
  end

  describe 'Database Schema' do
    it { is_expected.to have_db_column :email }
    it { is_expected.to have_db_column :encrypted_password }
    it { is_expected.to have_db_column :auth_token }

    # Timestamps
    it { is_expected.to have_db_column :created_at }
    it { is_expected.to have_db_column :updated_at }
  end

  describe 'Validation' do
    subject { FactoryGirl.build(:user) }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to validate_confirmation_of :password }
    it { is_expected.to allow_value('a@a.com', 'a@1b.net').for(:email) }
    it { is_expected.to_not allow_value('a@a', 'a@1b,net', '!d@e.se').for(:email) }
    it { is_expected.to validate_uniqueness_of :auth_token }
  end

  describe '#generate_authentication_token!' do
    it 'generate a unique token' do
      expect(Devise).to receive(:friendly_token).and_return('auniquetoken123')
      user.generate_authentication_token!
      expect(user.auth_token).to eql 'auniquetoken123'
    end

    it 'generates another token when one has already been taken' do
      existing_user = FactoryGirl.create(:user, auth_token: 'auniquetoken123')
      user.generate_authentication_token!
      expect(user.auth_token).not_to eql existing_user.auth_token
    end
  end
end
