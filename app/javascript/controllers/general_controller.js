import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "smsSendCodeForm",
    "smsResendCodeForm",
    "smsVerifyCodeForm",
    "phoneNumberVerificationLabel"
  ]

  // connect() {}
  // disconnect() {}
  smsSendSuccess(event) {
    let [data, status, xhr] = event.detail;

    this.smsSendCodeFormTarget.classList.toggle("show");
    this.smsResendCodeFormTarget.classList.toggle("show");
    this.smsVerifyCodeFormTarget.classList.toggle("show");

    window["alertify"][data.message.type](data.message.content);
  }

  smsResendSuccess(event) {
    let [data, status, xhr] = event.detail;

    // this.smsResendCodeFormTarget.classList.toggle("collapse")
    // console.log(data.message);
    window["alertify"][data.message.type](data.message.content);
  }

  smsVerifySuccess(event) {
    let [data, status, xhr] = event.detail;

    this.smsResendCodeFormTarget.classList.toggle("show");
    this.smsVerifyCodeFormTarget.classList.toggle("show");

    this.phoneNumberVerificationLabelTarget.classList.toggle("badge-warning");
    this.phoneNumberVerificationLabelTarget.classList.toggle("badge-success");

    window["alertify"][data.message.type](data.message.content);
  }

  errors(event) {
    let [data, status, xhr] = event.detail;
    if(data.object) {
      helpers.flicker(data.object, this, "danger");
    }

    alertify.dismissAll();
    if(data.error_messages) {
      data.error_messages.forEach(function(error_message) {
        alertify.error(error_message);
      });
    }

    if(data.message) {
      alertify[data.message.type](data.message.content);
    }
  }
}
