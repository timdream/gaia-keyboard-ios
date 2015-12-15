//
//  KeyboardWebAppView.swift
//  gaia-keyboard-ios
//
//  Created by Timothy on 12/3/14.
//  Copyright (c) 2014 Tim Chien. All rights reserved.
//

import UIKit
import WebKit

class KeyboardWebAppView : UIInputView {
    var webView: WKWebView!
    var expendedHeight: CGFloat = 400

    var kbDelegate: KeyboardViewController!
    var apiController: KeyboardWebAppAPIController!

    override init(frame: CGRect, inputViewStyle: UIInputViewStyle) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        self.createWebView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createWebView()
    }

    private func createWebView() {
        if #available(iOSApplicationExtension 9.0, *) {
            self.allowsSelfSizing = true
        }

        let screenSize = UIScreen.mainScreen().bounds.size;

        let rect = CGRect(x: 0, y: -screenSize.height + self.expendedHeight,
                            width: screenSize.width, height: screenSize.height)

        self.apiController = KeyboardWebAppAPIController()
        let configuration = self.apiController.configuration
        self.webView = WKWebView(frame: rect, configuration: configuration);

        self.addSubview(self.webView)
    }

    override func updateConstraints() {
//        self.webView.updateConstraints = self.expendedHeight
        super.updateConstraints()
    }

    func load() {
        self.apiController.appViewDelegate = self
        self.apiController.kbDelegate = self.kbDelegate

        let bundle = NSBundle.mainBundle();
        let path = bundle.pathForResource("index", ofType: "html", inDirectory: "webapp" );
        let url = NSURL(fileURLWithPath: path!);

        let req = NSURLRequest(URL: url)
        self.webView.loadRequest(req)
    }

    func getFocus() {
        self.apiController.inputMethodHandler.getFocus();
    }

    func removeFocus() {
        self.apiController.inputMethodHandler.removeFocus();
        self.webView.removeFromSuperview();
        self.webView = nil;
    }

    func updateTextInput() {
        self.apiController.inputMethodHandler.updateSelectionContext(false);
    }
}
