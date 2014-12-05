'use strict';

(function bootstrapAPIs(exports) {
  navigator.mozSettings = new NavigatorMozSettings();
  navigator.mozSettings.start();

  navigator.mozInputMethod = new InputMethod();
  navigator.mozInputMethod.start();

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
