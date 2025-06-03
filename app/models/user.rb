class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes
  has_many :chats, dependent: :destroy
  has_many :messages, through: :chat
  has_many :house_users
  has_many :houses, through: :house_users

  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
end
