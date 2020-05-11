class User < ApplicationRecord
  # before_save { self.email = self.email.downcase }
  # before_save { self.email = email.downcase }
  before_save {email.downcase!}
  validates :name,  presence: true, length:{maximum: 50 }
  #ドッド２つ未対応 VALID_EMIAL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMIAL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length:{maximum: 255}, 
                    format:{with: VALID_EMIAL_REGEX}, 
                    # uniqueness: true
                    uniqueness:{case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  #test_fixture用
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
end
