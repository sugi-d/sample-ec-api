require 'rails_helper'

RSpec.describe Point, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe '#add_registration_rewards!(user_id)' do
    it 'should be created new record that kind is registration and amount is 10,000' do
      obj = described_class.add_registration_rewards!(user.id)
      expect(obj.persisted?).to be_truthy
      expect(obj.registration?).to be_truthy
      expect(obj.amount).to eq(described_class::REGISTRATION_REWARD_POINTS)
      expect(obj.amount).to eq(10_000)
    end
  end

  describe '#buying_power(user_id)' do
    it 'should returns 20_000' do
      User.skip_callback(:create, :after, :add_registration_reward_points!)
      FactoryBot.create(:point, amount: 10_000, user_id: user.id, kind: :registration)
      trn = FactoryBot.create(:transaction, user_id: user.id)
      FactoryBot.create(:point, transaction_id: trn.id, amount: 10_000, user_id: user.id, kind: :buying)

      User.set_callback(:create, :after, :add_registration_reward_points!)
      expect(described_class.buying_power(user.id)).to eq(20_000)
    end
  end
end
