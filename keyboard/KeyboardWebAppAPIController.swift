//
//  KeyboardWebAppAPIController.swift
//  gaia-keyboard-ios
//
//  Created by Timothy on 12/4/14.
//  Copyright (c) 2014 Tim Chien. All rights reserved.
//

import Foundation
import WebKit

class KeyboardWebAppAPIController: NSObject, WKScriptMessageHandler {
    var configuration: WKWebViewConfiguration!
    var appViewDelegate: KeyboardWebAppView!
    var kbDelegate: KeyboardViewController!

    var settingsHandler: KeyboardWebAppSettingsHandler!
    var inputMethodHandler: KeyboardWebAppInputMethodHandler!

    override init() {
        super.init()
        self.configuration = self.createWebViewConfiguration()

        self.settingsHandler = KeyboardWebAppSettingsHandler();
        self.settingsHandler.apiControllerDelegate = self

        self.inputMethodHandler = KeyboardWebAppInputMethodHandler();
        self.inputMethodHandler.apiControllerDelegate = self
    }

    private func createWebViewConfiguration() -> WKWebViewConfiguration {
        let userContentController = WKUserContentController();
        userContentController.addScriptMessageHandler(self, name: "api");

        // The script files must loaded in the specified order
        let scriptFilenames = ["es6-shim.min", "event_target", "dom_request",
            "input_method", "keyboard_event", "settings", "bootstrap"];

        for scriptFilename in scriptFilenames {
            let loaderScriptPath = NSBundle.mainBundle()
                .pathForResource(scriptFilename, ofType: "js", inDirectory: "api" );
            let source = try? String(
                contentsOfFile: loaderScriptPath!,
                encoding: NSUTF8StringEncoding);

            let userScript = WKUserScript(
                source: source!,
                injectionTime: WKUserScriptInjectionTime.AtDocumentStart,
                forMainFrameOnly: true);

            userContentController.addUserScript(userScript);
        }

        let configuration = WKWebViewConfiguration();
        configuration.userContentController = userContentController;

        return configuration;
    }

    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message:WKScriptMessage) {
        let data : NSDictionary = message.body as! NSDictionary;
        let api = data["api"] as! String;
        switch api {
            case "settings":
                self.settingsHandler.handleMessage(data);

            case "inputmethod", "inputcontext", "inputmethodmanager":
                self.inputMethodHandler.handleMessage(data);

            case "resizeTo":
                let args = data["args"] as! NSArray
                self.appViewDelegate.expendedHeight = args[1] as! CGFloat;
                self.appViewDelegate.updateConstraints();
                self.appViewDelegate.kbDelegate.updateViewConstraints();

            default:
                fatalError("KeyboardWebAppAPIController: Undefined message from api: \(api)");
        }
    }

    func postMessage(obj: AnyObject) {
        do {
            let jsonString = NSString(
                data: try NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions(rawValue: 0)),
                encoding: NSUTF8StringEncoding) as! String;

            self.appViewDelegate.webView?.evaluateJavaScript(
                "window.postMessage(\(jsonString) ,'*');",
                completionHandler: nil);
        } catch _ as NSError {
            fatalError("KeyboardWebAppAPIController: Error parsing data.");
        }
    }
}

