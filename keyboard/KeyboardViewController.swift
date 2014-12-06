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

        self.view.removeConstraint(self.heightConstraint)
        self.heightConstraint.constant = self.keyboardAppView!.expendedHeight
        self.view.addConstraint(self.heightConstraint)
    }

    override func loadView() {
        self.keyboardAppView = KeyboardWebAppView()
        self.view = self.keyboardAppView!
        self.keyboardAppView!.kbDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        self.view.addConstraint(self.heightConstraint);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        if !self.isManagingFocus {
            return;
        }

        self.keyboardAppView.updateTextInput();
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        self.keyboardAppView.getFocus();
        self.isManagingFocus = true;
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);

        self.keyboardAppView.removeFocus();
        self.isManagingFocus = false;
    }
}
