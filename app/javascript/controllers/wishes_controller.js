import { Controller } from "stimulus"
import * as helpers from "modules/helpers"

let debounced_async_filter = helpers.debounce( (params = {}, dom_target) => {
  let url = new URL("wishes", "http://localhost:3000");
  url.search = new URLSearchParams(params);

  fetch(url, {
    method: "GET",
    headers: {
      dataType: "text/html",
      "X-Requested-With": "XMLHttpRequest",
    },
    credentials: "same-origin",
  })
  .then( response => response.text() )
  .then(function(html) {
    dom_target.innerHTML = html;
    let children_array = Array.from(dom_target.children);
    children_array.forEach( target => target.classList.add("flicker-success"));
    setTimeout(function() {
      children_array.forEach(target => target.classList.remove("flicker-success"))
    }, 1500);
  })
  .catch( error => console.error("error: ", error) );
}, 1500);

export default class extends Controller {
  static targets = [
    "wishName",
    "wishDescription",
    "wishWishCategory",
    "wishWishUrgency",
    "wishList",
    "offersList",
    "offerDescription",
    "wishCategoriesFilterTags"
  ]

  // connect() {}
  // disconnect() {}
  indexSuccess(event) {
    let [data, status, xhr] = event.detail;
    this.wishListTarget.insertAdjacentHTML("afterbegin", xhr.response);
    this.wishNameTarget.value = "";
    this.wishDescriptionTarget.value = "";
    this.wishWishCategoryTarget.value = "";

    initPhotoSwipeFromDOM(".thumbnail-list-wrapper");
    BSN.initCallback(document.body);
  }

  editSuccess(event) {
    let [data, status, xhr] = event.detail;
    alertify.success(data["message"]);
  }

  offersPostSuccess(event) {
    let [data, status, xhr] = event.detail;
    this.offersListTarget.insertAdjacentHTML("afterbegin", xhr.response);
    this.offerDescriptionTarget.value = "";

    let async_hide = document.getElementById("async-hide");
    if(typeof(async_hide) != "undefined" && async_hide != null) {
      helpers.fadeOutEffect(async_hide)
      // async_hide.remove();
    }
    // initPhotoSwipeFromDOM(".thumbnail-list-wrapper");
    // BSN.initCallback(document.body);
  }

  filter(event) {
    let params = { wish_category_ids: [] };
    this.wishCategoriesFilterTagsTargets.filter(
      target => target.checked == true
    ).forEach(
      target => params.wish_category_ids.push(target.value)
    )
    debounced_async_filter(params, this.wishListTarget);
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

// document.getElementById("wish_wish_urgency_id_" + CSS.escape(data.wish.wish_urgency_id)).setAttribute("checked", "checked");
// document.querySelector("[for=wish_wish_urgency_id_" + CSS.escape(data.wish_urgency_id) +"]").classList.add("active")

// console.log(this.urgencyTargets[0]);
// this.urgencyLabelTargets.forEach(target => target.classList.remove("active"));
  // .findAll(target => target.checked)

// fetch("wishes.json", {
//     method: "GET",
//     credentials: "same-origin"
// })
// .then( response => response.json() )
// .then( json => console.log(json) )
// .catch( error => console.error('error:', error) );
