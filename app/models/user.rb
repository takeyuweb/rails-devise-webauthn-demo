class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :webauthn_user, dependent: :destroy
  delegate :passkeys, to: :webauthn_user, allow_nil: true
end
