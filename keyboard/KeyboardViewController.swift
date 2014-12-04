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
    var keyboardAppView: KeyboardWebAppView?

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func loadView() {
        self.keyboardAppView = KeyboardWebAppView()
        self.view = self.keyboardAppView!
        self.keyboardAppView!.kbDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.keyboardAppView!.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    }

}
