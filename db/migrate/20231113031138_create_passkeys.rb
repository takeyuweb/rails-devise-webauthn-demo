class CreatePasskeys < ActiveRecord::Migration[7.1]
  def change
    create_table :passkeys do |t|
      t.references :webauthn_user, null: false, foreign_key: true
      t.string :label, null: false
      t.string :external_id, null: false
      t.string :public_key, null: false
      t.integer :sign_count, default: 0, null: false
      t.datetime :last_used_at, null: false

      t.timestamps

      t.index [:webauthn_user_id, :external_id], unique: true
    end
  end
end
