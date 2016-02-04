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
    var expendedHeight: CGFloat = 413

    var kbDelegate: KeyboardViewController!
    var apiController: KeyboardWebAppAPIController!

    var webView: WKWebView!

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
        self.webView.sizeToFit()
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(self.webView)
    }

    private func destroyWebView() {
        self.webView.removeFromSuperview();
        self.webView = nil;

        self.apiController = nil
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

    func unload() {
        self.apiController.kbDelegate = nil
        self.apiController.appViewDelegate = nil

        self.destroyWebView()
    }

    func getFocus() {
        self.apiController.inputMethodHandler.getFocus();
    }

    func removeFocus() {
        self.apiController.inputMethodHandler.removeFocus();
    }

    func updateTextInput() {
        self.apiController.inputMethodHandler.updateSelectionContext(false);
    }

    func updateHeight(height: CGFloat) {
        self.expendedHeight = height;
        self.kbDelegate.heightConstraint.constant = height;

        let screenSize = UIScreen.mainScreen().bounds.size;
        let rect = CGRect(x: 0, y: -screenSize.height + self.expendedHeight,
            width: screenSize.width, height: screenSize.height)
        self.webView.frame = rect
    }

    override func updateConstraints() {
        super.updateConstraints()
    }
}
