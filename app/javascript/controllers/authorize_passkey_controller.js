import { Controller } from "@hotwired/stimulus";
import {
  supported,
  get,
  parseRequestOptionsFromJSON
} from "@github/webauthn-json/browser-ponyfill";

export default class extends Controller {
  static targets = ["form", "credentialField"];
  static values = {
    requestOptionsUrl: String
  };

  async formTargetConnected(element) {
    // Check if the browser supports WebAuthn.
    if (supported()) {
      if (PublicKeyCredential.isConditionalMediationAvailable) {
        // Check if the browser supports conditional mediation.
        // https://developer.mozilla.org/en-US/docs/Web/API/PublicKeyCredential/isConditionalMediationAvailable
        const isCMA = await PublicKeyCredential.isConditionalMediationAvailable();
        if (isCMA) {
          console.log("CMA is available");
          this.getChallengeAndSubmitCredential(isCMA);
        } else {
          console.log("CMA is not available");
        }
      } else {
        console.log("CMA is not supported");
      }
    } else {
      console.log("WebAuthn is not supported");
    }
  }

  signInWithPasskey(event) {
    event.preventDefault();
    this.getChallengeAndSubmitCredential();
  }

  getChallengeAndSubmitCredential(isCMA) {
    const data = new FormData(this.formTarget);
    data.delete('_method');

    fetch(this.requestOptionsUrlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "application/json",
      },
      body: data
    })
      .then(response => response.json())
      .then(async requestOption => {
        console.log(requestOption);
        // ここに成功時の処理を書く
        const credentialRequestOptions = parseRequestOptionsFromJSON({ publicKey: requestOption });
        if (isCMA) {
          // Conditional Mediation の場合は "conditional" を指定する
          // https://w3c.github.io/webappsec-credential-management/#mediation-requirements
          credentialRequestOptions['mediation'] = 'conditional';
        }
        const credentialRequestResponse = await get(credentialRequestOptions);
        this.credentialFieldTarget.value = JSON.stringify(credentialRequestResponse);
        this.formTarget.submit();
      })
      .catch(error => {
        console.error(error);
        // ここにエラー時の処理を書く
      });
  }
}
