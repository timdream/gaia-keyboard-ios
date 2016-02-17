'use strict';

(function bootstrapAPIs(exports) {
  // XXX We don't know how to set this from Swift world
  window.location.hash = '#en';

  navigator.mozSettings = new NavigatorMozSettings();
  navigator.mozSettings.start();

  navigator.mozInputMethod = new InputMethod();
  navigator.mozInputMethod.start();

  window.addEventListener('load', function addCSS() {
    window.removeEventListener('load', addCSS);

    var link = document.createElement('link');
    link.rel = 'stylesheet';
    link.type = 'text/css';
    link.href = '../api/api.css';

    document.documentElement.firstElementChild.append(link);
  });

  window.resizeTo = function(width, height) {
    webkit.messageHandlers.api.postMessage({
      api: 'resizeTo',
      args: [width, height]
    });
  };

  if (!window.AudioContext && window.webkitAudioContext) {
    window.AudioContext = window.webkitAudioContext;
  }

  if (!('vibrate' in navigator)) {
    navigator.vibrate = function() { };
  };

  if (!('performance' in window)) {
    window.performance = {
      timing: {
      },
      now: function() { }
    };
  }

  if (!exports.WeakMap) {
    exports.WeakMap = exports.Map;
  } else {
    // Workarounds broken WeakMap implementation in JavaScriptCode
    // See https://bugs.webkit.org/show_bug.cgi?id=137651
    var weakMapPrototypeSet = exports.WeakMap.prototype.set;
    exports.WeakMap.prototype.set = function(key, val) {
      if (key instanceof HTMLElement) {
        key.webkitWeakMapWorkaround = 1;
      }
      weakMapPrototypeSet.call(this, key, val);
    };
  }
})(window);
