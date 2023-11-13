module Passkeyable
  extend ActiveSupport::Concern

  def store_authentication_challenge(options_for_authentication)
    session[:current_webauthn_authentication_challenge] = options_for_authentication.challenge
  end

  def store_registration_challenge(options_for_registration)
    session[:current_webauthn_registration_challenge] = options_for_registration.challenge
  end

  def stored_authentication_challenge
    session[:current_webauthn_authentication_challenge]
  end

  def stored_registration_challenge
    session[:current_webauthn_registration_challenge]
  end
end
