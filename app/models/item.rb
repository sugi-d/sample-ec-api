# == Schema Information
#
# Table name: items
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)        not null
#  name           :string(255)      not null
#  price          :integer          unsigned, not null
#  publish_status :integer          default("unpublished"), not null
#  status         :integer          default("activated"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Item < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :name, presence: true, length: { maximum: 255 }
  validates :price, presence: true
  validates :price, allow_blank: true, numericality: { greater_than: 0 }

  enum publish_status: { unpublished: 0, published: 1 }
  enum status: { deleted: 0, activated: 1 }
  # 商品はキャッシュ化するべきだが、今回は省く
  # after_save :create_cache

  def self.list(url, offset, limit)
    lists = select(:id, :name, :price).published.activated.page(offset).per(limit)
    ops = { limit: limit }
    next_url = url + '?' + ops.merge({ offset: lists.next_page }).to_query unless lists.blank? || lists.last_page?
    prev_url = url + '?' + ops.merge({ offset: lists.prev_page }).to_query unless lists.blank? || lists.first_page?

    lists = lists.map do |item|
      { id: item.id, name: item.name, price: item.price }
    end

    {
      items: lists,
      prev_url: prev_url,
      next_url: next_url
    }
  end

  def logical_delete
    update(status: :deleted)
  end

  def viewable?
    published? && activated?
  end
end
