import { Controller } from "@hotwired/stimulus";
import {
  create,
  parseCreationOptionsFromJSON
} from "@github/webauthn-json/browser-ponyfill";

export default class extends Controller {
  static targets = ["form", "credentialField"];
  static values = {
    creationOptionsUrl: String
  };

  submit(event) {
    event.preventDefault();

    const data = new FormData(this.formTarget);
    data.delete('_method');

    fetch(this.creationOptionsUrlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "application/json",
      },
      body: data
    })
      .then(response => response.json())
      .then(async creationOption => {
        console.log(creationOption);
        // ここに成功時の処理を書く
        const credentialCreationOptions = parseCreationOptionsFromJSON({ publicKey: creationOption });
        const credentialCreationResponse = await create(credentialCreationOptions);
        this.credentialFieldTarget.value = JSON.stringify(credentialCreationResponse);
        this.formTarget.submit();
      })
      .catch(error => {
        console.error(error);
        // ここにエラー時の処理を書く
      });
  }
}
