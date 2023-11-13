import { Controller } from "@hotwired/stimulus";
import {
  get,
  parseRequestOptionsFromJSON
} from "@github/webauthn-json/browser-ponyfill";

export default class extends Controller {
  static targets = ["form", "credentialField"];
  static values = {
    requestOptionsUrl: String
  };

  signInWithPasskey(event) {
    event.preventDefault();
    this.getChallengeAndSubmitCredential();
  }

  getChallengeAndSubmitCredential() {
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
