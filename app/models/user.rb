class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :auth_token, uniqueness: true
  before_create :generate_authentication_token!

  has_many :monsters, dependent: :destroy
  has_many :teams, dependent: :destroy

  def generate_authentication_token!
    begin 
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def self.from_facebook(fb_auth)
    where(provider: "facebook", uid: fb_auth[:uid]).first_or_create do |user|
      user.email = fb_auth[:email]
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
