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

        self.inputView!.removeConstraint(self.heightConstraint)
        self.heightConstraint.constant = self.keyboardAppView!.expendedHeight
        self.inputView!.addConstraint(self.heightConstraint)
    }

    override func loadView() {
        // XXX for some reason, UIInputViewController does not appear to follow
        // the normal UIViewController lifecycle, so we run into this loadView()
        // function every time.
        self.keyboardAppView = KeyboardWebAppView()
        self.keyboardAppView!.kbDelegate = self
        self.inputView = self.keyboardAppView
        self.keyboardAppView!.load()

        self.heightConstraint =
            NSLayoutConstraint(item: self.view,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier:0.0,
                constant: self.keyboardAppView!.expendedHeight)

        // We need to bump the pirority of our constraint here.
        // See http://stackoverflow.com/a/25795758/519617
        self.heightConstraint.priority = 999;

        self.inputView!.addConstraint(self.heightConstraint);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);

        self.keyboardAppView.getFocus();
        self.isManagingFocus = true;
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
