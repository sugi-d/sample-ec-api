# == Schema Information
#
# Table name: points
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)        not null
#  transaction_id :bigint(8)
#  amount         :integer          not null
#  kind           :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Point < ApplicationRecord
  REGISTRATION_REWARD_POINTS = 10_000

  belongs_to :user
  # transaction が ActiveRecord のメソッドとコンフリするため
  belongs_to :trn, class_name: 'Transaction', optional: true

  validates :transaction_id, presence: true, unless: -> { self.registration? }

  enum kind: { registration: 10, selling: 20, buying: 30 }

  def self.add_registration_rewards!(user_id)
    create!(user_id: user_id, amount: REGISTRATION_REWARD_POINTS, kind: :registration)
  end

  def self.buying_power(user_id)
    where(user_id: user_id).sum(:amount)
  end
end
