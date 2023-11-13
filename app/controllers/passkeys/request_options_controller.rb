class Passkeys::RequestOptionsController < ApplicationController
  include Passkeyable

  def create
    user_params = params.require(:user).permit(:email)
    user = User.find_by(email: user_params[:email])

    # https://www.w3.org/TR/webauthn/#dictionary-assertion-options
    request_options = WebAuthn::Credential.options_for_get(
      user_verification: "required",  # ユーザー認証を要求する
      allow: user ? user.passkeys.pluck(:external_id) : nil,  # メールアドレスからユーザーが特定できれば、登録済みのパスキーで絞り込む
    )

    store_authentication_challenge(request_options)

    render json: request_options
  end
end
