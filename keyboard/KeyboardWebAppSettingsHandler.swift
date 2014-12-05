//
//  KeyboardWebAppSettingsHandler.swift
//  gaia-keyboard-ios
//
//  Created by Timothy on 12/5/14.
//  Copyright (c) 2014 Tim Chien. All rights reserved.
//

import Foundation

class KeyboardWebAppSettingsHandler {
    var apiControllerDelegate: KeyboardWebAppAPIController!

    var settings: NSMutableDictionary

    init() {
        self.settings = NSMutableDictionary()
        self.settings["keyboard.wordsuggestion"] = true;
        self.settings["keyboard.autocorrect"] = true;
        self.settings["keyboard.vibration"] = true;
        self.settings["audio.volume.notification"] = 10;
        self.settings["keyboard.handwriting.strokeWidth"] = 10;
        self.settings["keyboard.handwriting.responseTime"] = 500;
    }

    func handleMessage(data: NSDictionary) {
        let method = data["method"] as String;
        let args = data["args"] as [AnyObject];

        let message = NSMutableDictionary();
        message["api"] = data["api"];
        message["lockId"] = data["lockId"];
        message["id"] = data["id"];

        switch method {
            case "get":
                let result = NSMutableDictionary();
                let key = args[0] as String;
                result.setValue(self.settings[key], forKey: key);
                message["result"] = result;

                self.apiControllerDelegate.postMessage(message);

            case "set":
                let dict = args[0] as NSDictionary;
                for key in dict.allKeys as [String] {
                    self.settings[key] = dict[key];
                }
                message["result"] = args[0];

                self.apiControllerDelegate.postMessage(message);

            case "clear":
                let key = args[0] as String;
                self.settings.removeObjectForKey(key);
                message["result"] = args[0];

                self.apiControllerDelegate.postMessage(message);

            default:
                fatalError("KeyboardWebAppSettingsAPI: Unsupported method.");
        }
    }
}
