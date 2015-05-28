require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { FactoryGirl.build(:product) }

  describe 'Fixtures' do
    it 'should have valid Fixtures Factory' do
      expect(FactoryGirl.create(:product)).to be_valid
    end
  end

  describe 'Database Schema' do
    it { is_expected.to have_db_column :title }
    it { is_expected.to have_db_column :price }
    it { is_expected.to have_db_column :published }
    it { is_expected.to have_db_column :user_id }

    # Indexes
    it { is_expected.to have_db_index :user_id }

    # Timestamps
    it { is_expected.to have_db_column :created_at }
    it { is_expected.to have_db_column :updated_at }
  end

  describe 'Validation' do
    subject { FactoryGirl.build(:product) }

    # it { is_expected.to not_be_published }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of :user_id }
  end
end
