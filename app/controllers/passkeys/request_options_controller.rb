class Passkeys::RequestOptionsController < ApplicationController
  def create
    user_params = params.require(:user).permit(:email)
    user = User.find_by!(email: user_params[:email])

    # https://www.w3.org/TR/webauthn/#dictionary-assertion-options
    request_options = WebAuthn::Credential.options_for_get(
      user_verification: "required",  # ユーザー認証を要求する
      allow: user.passkeys&.pluck(:external_id),  # メールアドレスからユーザーが特定し、登録済みのパスキーで絞り込む
    )

    session[:current_webauthn_authentication_challenge] = request_options.challenge

    render json: request_options
  end
end
