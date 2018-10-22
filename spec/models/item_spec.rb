require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { FactoryBot.create(:item) }

  describe '#list(url, offset, limit)' do
    context 'when offset is 0, limit is 1' do
      it 'should returns item2' do
        item2 = FactoryBot.create(:item, status: :activated, publish_status: :published)
        FactoryBot.create(:item, status: :activated, publish_status: :published)
        FactoryBot.create(:item, status: :activated, publish_status: :unpublished)
        FactoryBot.create(:item, status: :deleted, publish_status: :published)
        FactoryBot.create(:item, status: :deleted, publish_status: :unpublished)

        list = described_class.list('dummy', 0, 1)
        expect(list[:items].size).to eq(1)
        expect(list[:items][0][:id]).to eq(item2.id)
        expect(list[:items][0][:name]).to eq(item2.name)
        expect(list[:items][0][:price]).to eq(item2.price)
        expect(list[:prev_url]).to be_nil
        expect(list[:next_url]).to eq('dummy?limit=1&offset=2')
      end
    end

    context 'when offset is 2, limit is 2' do
      it 'should returns item2, item3' do
        FactoryBot.create(:item, status: :activated, publish_status: :published)
        FactoryBot.create(:item, status: :activated, publish_status: :published)
        item2 = FactoryBot.create(:item, status: :activated, publish_status: :published)
        item3 = FactoryBot.create(:item, status: :activated, publish_status: :published)

        list = described_class.list('dummy', 2, 2)
        expect(list[:items].size).to eq(2)
        expect(list[:items][0][:id]).to eq(item2.id)
        expect(list[:items][1][:id]).to eq(item3.id)
        expect(list[:prev_url]).to eq('dummy?limit=2&offset=1')
        expect(list[:next_url]).to be_nil
      end
    end
  end

  describe '#logical_delete' do
    it 'should be changed to deleted' do
      expect { item.logical_delete }.to change { item.status }.from('activated').to('deleted')
    end
  end

  describe '#viewable?' do
    context 'when publish_status is unpublished, status is deleted' do
      it 'should returns false' do
        item.update!(publish_status: :unpublished, status: :deleted)
        expect(item.viewable?).to be_falsey
      end
    end

    context 'when publish_status is published, status is deleted' do
      it 'should returns false' do
        item.update!(publish_status: :published, status: :deleted)
        expect(item.viewable?).to be_falsey
      end
    end

    context 'when publish_status is unpublished, status is activated' do
      it 'should returns false' do
        item.update!(publish_status: :unpublished, status: :activated)
        expect(item.viewable?).to be_falsey
      end
    end

    context 'when publish_status is published, status is activated' do
      it 'should returns true' do
        item.update!(publish_status: :published, status: :activated)
        expect(item.viewable?).to be_truthy
      end
    end
  end
end
