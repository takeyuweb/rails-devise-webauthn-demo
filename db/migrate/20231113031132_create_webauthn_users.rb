class CreateWebauthnUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :webauthn_users do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :webauthn_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
