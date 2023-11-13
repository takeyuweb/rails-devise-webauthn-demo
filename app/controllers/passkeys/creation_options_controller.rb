class Passkeys::CreationOptionsController < ApplicationController
  # See https://github.com/cedarcode/webauthn-ruby#options-for-create
  # https://www.w3.org/TR/webauthn/#dictdef-publickeycredentialcreationoptions
  def create
    passkey_params = params.require(:passkey).permit(:label)

    creation_options = WebAuthn::Credential.options_for_create(
      user: { id: find_or_create_webauthn_id, name: current_user.email, display_name: passkey_params[:label] },
      exclude: current_user.passkeys.pluck(:external_id), # 登録済みの鍵は除外する。
      authenticator_selection: {
        resident_key: "required", # 2023年11月現在、Android Chrome でパスキーを使うには residentKey が必須
        require_resident_key: true,
        user_verification: "required" # 認証器でのユーザー認証を要求する
      }
    )

    session[:current_webauthn_registration_challenge] = creation_options.challenge

    render json: creation_options
  end

  private

  def find_or_create_webauthn_id
    return current_user.webauthn_user.webauthn_id if current_user.webauthn_user

    current_user.create_webauthn_user(webauthn_id: WebAuthn.generate_user_id).webauthn_id
  end
end
