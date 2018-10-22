require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '#buy!(user_id, item_id)' do
    let(:user) { FactoryBot.create(:user) }
    let(:item) { FactoryBot.create(:item) }

    it 'should be created a transaction, two points' do
      trn = described_class.find_by(user_id: user.id, item_id: item.id, price: item.price)
      buy = Point.find_by(user_id: user.id, kind: :buying, amount: -item.price)
      sell = Point.find_by(user_id: item.user_id, kind: :selling, amount: item.price)
      expect(trn.present?).to be_falsey
      expect(buy.present?).to be_falsey
      expect(sell.present?).to be_falsey

      described_class.buy!(user.id, item.id)
      trn = described_class.find_by(user_id: user.id, item_id: item.id, price: item.price)
      buy = Point.find_by(user_id: user.id, kind: :buying, amount: -item.price)
      sell = Point.find_by(user_id: item.user_id, kind: :selling, amount: item.price)
      expect(trn.present?).to be_truthy
      expect(buy.present?).to be_truthy
      expect(sell.present?).to be_truthy
    end
  end

  describe '#enough_buying_power' do
    let!(:transaction) { FactoryBot.create(:transaction, price: 10) }

    before { allow_any_instance_of(described_class).to receive(:correct_item_and_self_dealing).and_return(true) }

    context 'when buying power is 11, price is 10' do
      it 'should be valid' do
        allow(Point).to receive(:buying_power).and_return(11)
        transaction.send(:enough_buying_power)
        expect(transaction).to be_valid
      end
    end

    context 'when buying power is 10, price is 10' do
      it 'should be valid' do
        allow(Point).to receive(:buying_power).and_return(10)
        transaction.send(:enough_buying_power)
        expect(transaction).to be_valid
      end
    end

    context 'when buying power is 9, price is 10' do
      it 'should be added not_enough_buying_power errors' do
        allow(Point).to receive(:buying_power).and_return(9)
        transaction.send(:enough_buying_power)
        expect(transaction.errors.full_messages).to eq([I18n.t('activerecord.errors.models.point.not_enough_buying_power')])
      end
    end
  end

  describe '#correct_item_and_self_dealing' do
    let!(:transaction) { FactoryBot.create(:transaction) }

    before { allow_any_instance_of(described_class).to receive(:enough_buying_power).and_return(true) }

    context 'when viewable? is false' do
      it 'should be added incorrect_item error' do
        allow_any_instance_of(Item).to receive(:viewable?).and_return(false)
        transaction.send(:correct_item_and_self_dealing)
        expect(transaction.errors.full_messages).to eq([I18n.t('activerecord.errors.models.point.incorrect_item')])
      end
    end

    context 'when viewable? is true and is not transaction by the same user' do
      it 'should be valid' do
        allow_any_instance_of(Item).to receive(:viewable?).and_return(true)
        transaction.send(:correct_item_and_self_dealing)
        expect(transaction).to be_valid
      end
    end

    context 'when viewable? is true and is transaction by the same user' do
      it 'should be added self_dealing error' do
        transaction.item.update!(user_id: transaction.user_id)
        transaction.send(:correct_item_and_self_dealing)
        expect(transaction.errors.full_messages).to eq([I18n.t('activerecord.errors.models.point.self_dealing')])
      end
    end
  end
end
