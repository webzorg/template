// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("trix")
require("@rails/actiontext")

import "controllers"

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
window.alertify = require("alertifyjs")
window.PhotoSwipe = require("photoswipe/dist/photoswipe.min")
window.PhotoSwipeUI_Default = require("photoswipe/dist/photoswipe-ui-default.min")
window.autosize = require("autosize/dist/autosize.min.js")
require("bootstrap.native/dist/bootstrap-native-v4")
require("modules/photo-swipe-dom-initializer")

document.addEventListener("turbolinks:load", function() {
  BSN.initCallback(document.body);
  // helpers.fadeOutEffectAndHide(document.getElementById("before-page-spinner"));

  autosize(document.querySelectorAll("textarea"));

  // initPhotoSwipeFromDOM(".thumbnail-list-wrapper");
});

