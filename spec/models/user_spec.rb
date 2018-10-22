require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe '#cache_key(id, login_token)' do
    it 'returns {class_name}_{id}_{login_token}' do
      expect(described_class.cache_key(1, 'test')).to eq('user_1_test')
    end
  end

  describe '#refresh_token' do
    it 'should be called Rails.cache.delete with cache_key' do
      expect(described_class).to receive(:cache_key).with(user.id, user.login_token).once.and_return('test')
      expect(Rails.cache).to receive(:delete).with('test').once
      user.refresh_token
    end

    it 'should be changed login_token' do
      old_token = user.login_token
      expect { user.refresh_token }.to change { user.login_token }.from(old_token)
    end
  end

  describe '#add_registration_reward_points!' do
    context 'when user created' do
      it 'should be called Point.add_registration_rewards!(id)' do
        expect(Point).to receive(:add_registration_rewards!).once
        user = FactoryBot.build(:user)
        user.save!
      end
    end
  end
end
