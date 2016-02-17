# Gaia Keyboard iOS

An attempt to run [Gaia Keyboard](https://github.com/mozilla-b2g/gaia/tree/master/apps/keyboard) as an [iOS Custom Keyboard](https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/Keyboard.html).

Related project: [Gaia Keyboard Demo](https://github.com/timdream/gaia-keyboard-demo), which attempt to run the same keyboard on the normal web page.

## Getting Started

1. Clone the Gaia repo separately into `gaia` sub-directory.

        git clone https://github.com/mozilla-b2g/gaia.git

2. Pull the necessary files into the Xcode project

        make -C keyboard

3. Launch Xcode and build the code.

## Underneath

It pulls the keyboard codebase from [Gaia](https://github.com/mozilla-b2g/gaia), and re-implements `navigator.mozInputMethod` API so we could communicate between the Swift world and the app.

Additionally, other missing APIs that is not provided on Safari Mobile are shimmed.
