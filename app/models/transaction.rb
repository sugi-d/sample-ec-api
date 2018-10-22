# == Schema Information
#
# Table name: transactions
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  item_id    :bigint(8)        not null
#  price      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :item
  has_many :points

  validates :price, presence: true
  validates :price, allow_blank: true, numericality: { greater_than: 0 }
  validate :enough_buying_power
  validate :correct_item_and_self_dealing

  def self.buy!(user_id, item_id)
    item = Item.find_by(id: item_id)
    transaction do
      trn = create!(user_id: user_id, item_id: item_id, price: item.price)
      trn.points.create!(user_id: user_id, amount: -trn.price, kind: :buying)
      trn.points.create!(user_id: item.user_id, amount: trn.price, kind: :selling)
    end
  end

  private
    def enough_buying_power
      return if price <= Point.buying_power(user_id)
      errors.add(:base, I18n.t('activerecord.errors.models.point.not_enough_buying_power'))
    end

    def correct_item_and_self_dealing
      item = Item.find(item_id)
      unless item.viewable?
        return errors.add(:base, I18n.t('activerecord.errors.models.point.incorrect_item'))
      end

      if item.user_id == user_id
        return errors.add(:base, I18n.t('activerecord.errors.models.point.self_dealing'))
      end
    end
end
