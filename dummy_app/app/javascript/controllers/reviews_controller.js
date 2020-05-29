import { Controller } from "stimulus"
import * as helpers from "modules/helpers"

export default class extends Controller {
  static targets = [
    "reviewList",
    "reviewRating",
    "reviewContent"
  ]

  // connect() {}
  // disconnect() {}
  postSuccess(event) {
    let [data, status, xhr] = event.detail;
    this.reviewListTarget.insertAdjacentHTML("afterbegin", xhr.response);
    // this.reviewContentTarget.value = "";


    // initPhotoSwipeFromDOM(".thumbnail-list-wrapper");
    // BSN.initCallback(document.body);
  }

  errors(event) {
    let [data, status, xhr] = event.detail;
    helpers.flicker(data.object, this, "danger");

    alertify.dismissAll();
    data.error_messages.forEach(function(error_message) {
      alertify.error(error_message);
    });
  }
}
