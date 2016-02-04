//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Timothy on 12/3/14.
//  Copyright (c) 2014 Tim Chien. All rights reserved.
//

import UIKit
import WebKit

class KeyboardViewController: UIInputViewController {
    var keyboardAppView: KeyboardWebAppView!

    var isManagingFocus: Bool = false
    var heightConstraint: NSLayoutConstraint!

    override func updateViewConstraints() {
        super.updateViewConstraints()

        if (self.inputView!.frame.size.width == 0 || self.inputView!.frame.size.height == 0) {
            return
        }
        self.heightConstraint.constant = self.keyboardAppView!.expendedHeight
    }

/*
    override func loadView() {
        super.loadView();
    }
*/

    override func viewDidLoad() {
        super.viewDidLoad()

        self.keyboardAppView = KeyboardWebAppView()
        self.keyboardAppView.kbDelegate = self
        self.keyboardAppView.load()

        self.inputView!.addSubview(self.keyboardAppView.webView)

        self.heightConstraint =
            NSLayoutConstraint(item: self.inputView!,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: self.keyboardAppView!.expendedHeight)

        // We need to bump the pirority of our constraint here.
        // See http://stackoverflow.com/a/25795758/519617
        self.heightConstraint.priority = UILayoutPriority(999);

        self.inputView!.addConstraint(self.heightConstraint);
        self.inputView!.translatesAutoresizingMaskIntoConstraints = false;
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);

        self.keyboardAppView.getFocus();
        self.isManagingFocus = true;


        let appViewLeftSideConstraint =
            NSLayoutConstraint(item: self.keyboardAppView.webView, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let appViewRightSideConstraint =
            NSLayoutConstraint(item: self.keyboardAppView.webView, attribute: .Right, relatedBy: .Equal, toItem: self.inputView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let appViewBottomSideConstraint =
            NSLayoutConstraint(item: self.keyboardAppView.webView, attribute: .Bottom, relatedBy: .Equal, toItem: self.inputView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([
            appViewLeftSideConstraint, appViewRightSideConstraint, appViewBottomSideConstraint])
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);

        self.keyboardAppView.removeFocus();
        self.isManagingFocus = false;
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);

        // XXX: Since UIInputViewController is reloaded everytime, we should throw out
        // old stuff here...
        self.keyboardAppView.unload()
        self.keyboardAppView!.kbDelegate = nil
        self.keyboardAppView = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        if !self.isManagingFocus {
            return;
        }

        self.keyboardAppView.updateTextInput();
    }
}
