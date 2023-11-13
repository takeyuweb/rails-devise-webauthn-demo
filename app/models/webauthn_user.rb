class WebauthnUser < ApplicationRecord
  belongs_to :user
  has_many :passkeys, dependent: :destroy
  validates :webauthn_id, presence: true, uniqueness: true
end
