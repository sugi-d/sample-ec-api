# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  login_token     :string(255)      not null
#  status          :integer          default("unactivated"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :points
  has_many :items
  has_many :transactions

  has_secure_password validations: false
  has_secure_token :login_token

  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :email, allow_blank: true, format: { with: EMAIL_REGEX }

  validates :password, presence: true, if: -> { self.password_digest.blank? }
  validates :password, allow_blank: true, length: { minimum: 6, maximum: 255 }
  validates_confirmation_of :password, allow_blank: true, on: [:create, :update]

  enum status: { unactivated: 0, activated: 1 }

  after_create :add_registration_reward_points!

  # Override knock method
  def self.from_token_request(request)
    user = self.find_by(email: request.params['auth']['email'])
    raise Exceptions::UserNotFoundError if user.blank?
    user.refresh_token
    user
  end

  # Override knock method
  def self.from_token_payload(payload)
    id, login_token = payload['id'], payload['token']
    Rails.cache.fetch(cache_key(id, login_token)) do
      find_by(id: id, login_token: login_token, status: :activated)
    end
  end

  # Override knock method
  def to_token_payload
    { id: id, token: login_token }
  end

  def self.cache_key(id, login_token)
    "#{self.to_s.underscore}_#{id}_#{login_token}"
  end

  def refresh_token
    Rails.cache.delete(self.class.cache_key(id, login_token))
    regenerate_login_token
  end

  private
    def add_registration_reward_points!
      Point.add_registration_rewards!(id)
    end
end
