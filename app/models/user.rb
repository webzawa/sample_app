# frozen_string_literal: true

class User < ApplicationRecord
  # before_save { self.email = self.email.downcase }
  # before_save { self.email = email.downcase }

  attr_accessor :remember_token
  before_save { email.downcase! }

  validates :name,  presence: true, length: { maximum: 50 }
  # ドッド２つ未対応 VALID_EMIAL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMIAL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMIAL_REGEX },
                    # uniqueness: true
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # test_fixtureにも使用
  def self.digest(string)
    # Ruby的に正しい書き方
    # def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    # Ruby的に正しい書き方
    # def self.new_token
    SecureRandom.urlsafe_base64
  end

  # permanent_sessionのためにUserをDBに保存
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたtokenがdigestと一致したらtrueを返却
  def authenticated?(remember_token)
    # 記憶digestがnilの際はfalseを返す
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)

    # 以下の書き方でも良い
    # if remember_digest.nil?
    #   false
    # else
    #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
    # end
  end

  # delete login_information
  def forget
    update_attribute(:remember_digest, nil)
  end
end
