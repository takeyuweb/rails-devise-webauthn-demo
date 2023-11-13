class Passkey < ApplicationRecord
  belongs_to :webauthn_user

  validates :label, presence: true
  validates :external_id, presence: true, uniqueness: { scope: :webauthn_user_id }
  validates :public_key, presence: true
  validates :sign_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :last_used_at, presence: true
end
