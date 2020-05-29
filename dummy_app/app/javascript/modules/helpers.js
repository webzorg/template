export const debounce = require("lodash/debounce")

export const toCamel = (s) => {
  return s.replace(/([-_][a-z])/ig, ($1) => {
    return $1.toUpperCase().replace("-", "").replace("_", "");
  });
}

export const flicker = (object, this_local, type="success") => {
  for(let key in object.errors){
    let nameInputTarget = this_local[toCamel(object.class + "_" + key) + "Target"];

    nameInputTarget.classList.add("flicker-" + type);
    setTimeout(function() { nameInputTarget.classList.remove("flicker-" + type) }, 500);
  };
}

export const fadeInEffect = (fade_target) => {
  var fadeEffect = setInterval(function () {
    if (!fade_target.style.opacity) {
      fade_target.style.opacity = 0;
    }
    if (fade_target.style.opacity < 1) {
      fade_target.style.opacity += 0.1;
    } else {
      clearInterval(fadeEffect);
    }
  }, 100);
}

export const fadeOutEffect = (fade_target) => {
  var fadeEffect = setInterval(function () {
    if (!fade_target.style.opacity) {
      fade_target.style.opacity = 1;
    }
    if (fade_target.style.opacity > 0) {
      fade_target.style.opacity -= 0.1;
    } else {
      clearInterval(fadeEffect);
    }
  }, 100);
}

// export const fadeOutEffectAndHide = (fade_target) => {
//   var fadeEffect = setInterval(function () {
//     if (!fade_target.style.opacity) {
//       fade_target.style.opacity = 1;
//     }
//     if (fade_target.style.opacity > 0) {
//       fade_target.style.opacity -= 0.1;
//     } else {
//       fade_target.style.display = "none";
//       clearInterval(fadeEffect);
//     }
//   }, 100);
// }
