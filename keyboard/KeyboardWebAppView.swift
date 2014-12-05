//
//  KeyboardWebAppView.swift
//  gaia-keyboard-ios
//
//  Created by Timothy on 12/3/14.
//  Copyright (c) 2014 Tim Chien. All rights reserved.
//

import UIKit
import WebKit

class KeyboardWebAppView : UIView {
    var webView: WKWebView?
    var expendedHeight: CGFloat = 0

    var kbDelegate: KeyboardViewController!

    override init() {
        super.init();
        self.createWebView();
    }

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.createWebView();
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.createWebView();
    }

    private func createWebView() {
        let screenSize = UIScreen.mainScreen().bounds.size;

        let rect = CGRect(x: 0, y: -screenSize.height + self.expendedHeight,
                            width: screenSize.width, height: screenSize.height)
        self.webView = WKWebView(frame: rect)

        self.addSubview(self.webView!)
    }

    func load() {
        let bundle = NSBundle.mainBundle();
        let path = bundle.pathForResource("index", ofType: "html", inDirectory: "webapp" );
        let url = NSURL(fileURLWithPath: path!);

        let req = NSURLRequest(URL: url!)
        self.webView!.loadRequest(req)
    }
}
