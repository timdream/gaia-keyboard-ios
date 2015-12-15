//
//  KeyboardWebAppInputMethodHandler.swift
//  gaia-keyboard-ios
//
//  Created by Timothy on 12/5/14.
//  Copyright (c) 2014 Tim Chien. All rights reserved.
//

import Foundation
import UIKit

enum TextMutationTask {
    case UpdateComposition
    case Append
    case Return
    case Backspace
    case Replace
}

class KeyboardWebAppInputMethodHandler {
    var apiControllerDelegate: KeyboardWebAppAPIController!

    init() {
    }

    func handleMessage(data: NSDictionary) {
        let api = data["api"] as! String;

        switch api {
            case "inputcontext":
                self.handleInputContextMessage(data);

            case "inputmethodmanager":
                self.handleInputMethodManagerMessage(data);

            default:
                fatalError("KeyboardWebAppInputMethodHandler: Undefined API: \(api).")
        }
    }

    func getFocus() {
        let info = self.getSelectionInfo();

        let message = NSMutableDictionary();
        message["api"] = "inputmethod";
        message["method"] = "setInputContext";
        message["ctx"] = true;
        message["selectionStart"] = info["selectionStart"];
        message["selectionEnd"] = info["selectionEnd"];
        message["textBeforeCursor"] = info["textBeforeCursor"];
        message["textAfterCursor"] = info["textAfterCursor"];

        self.apiControllerDelegate.postMessage(message);
    }

    func removeFocus() {
        let message = NSMutableDictionary();
        message["api"] = "inputmethod";
        message["method"] = "setInputContext";
        message["ctx"] = false;

        self.apiControllerDelegate.postMessage(message);
    }

    func updateSelectionContext(ownAction: Bool = true) {
        let message = NSMutableDictionary();
        message["api"] = "inputcontext";
        message["method"] = "updateSelectionContext";

        let result = NSMutableDictionary();
        result["selectionInfo"] = self.getSelectionInfo();
        result["ownAction"] = ownAction;

        message["result"] = result;
        self.apiControllerDelegate.postMessage(message);
    }

    private func handleInputContextMessage(data: NSDictionary) {
        let method = data["method"] as! String;
        let args = data["args"] as! [AnyObject];

        let message = NSMutableDictionary();
        message["api"] = data["api"];
        message["contextId"] = data["contextId"];
        message["id"] = data["id"];


        switch method {
        case "getText":
            let textDocumentProxy : UITextDocumentProxy =
                self.apiControllerDelegate.kbDelegate.textDocumentProxy as UITextDocumentProxy;
            let text = (textDocumentProxy.documentContextBeforeInput! +
                textDocumentProxy.documentContextAfterInput!) as NSString;
            var result: String;

            // XXX We are handling USC-16 indexes passed from JavaScript as Unicode string indexes here.
            if args.count >= 2 {
                result = text.substringWithRange(NSRange(location: args[0] as! Int, length: args[1] as! Int));
            } else if args.count == 1 {
                result = text.substringFromIndex(args[0] as! Int);
            } else {
                result = text as String;
            }

            message["result"] = result;

            self.apiControllerDelegate.postMessage(message);

        case "sendKey":
            let charCode = args[1] as! Int;
            if charCode != 0 {
                self.handleInput(
                    TextMutationTask.Append,
                    str: String(UnicodeScalar(charCode)));
            } else {
                switch (args[0] as! Int) {
                case 0x08:
                    self.handleInput(TextMutationTask.Backspace);
                case 0x0D:
                    self.handleInput(TextMutationTask.Return);
                default:
                    print("KeyboardWebAppInputMethodHandler: Unhandled keyCode \(args[0])");
                }
            }

            self.updateSelectionContext();

            message["result"] = "";
            self.apiControllerDelegate.postMessage(message);

        case "replaceSurroundingText":
            self.handleInput(
                TextMutationTask.Replace,
                str: args[0] as! String,
                offset: args[1] as! Int,
                length: args[2] as! Int);

            self.updateSelectionContext();

            message["result"] = self.getSelectionInfo();
            self.apiControllerDelegate.postMessage(message);

        case "deleteSurroundingText":
            self.handleInput(
                TextMutationTask.Replace,
                str: "",
                offset: args[0] as! Int,
                length: args[1] as! Int);

            self.updateSelectionContext();

            message["result"] = self.getSelectionInfo();
            self.apiControllerDelegate.postMessage(message);

        case "setComposition":
            self.handleInput(
                TextMutationTask.UpdateComposition,
                str: args[0] as! String);

            self.updateSelectionContext();

            message["result"] = "";
            self.apiControllerDelegate.postMessage(message);

        case "endComposition":
            self.handleInput(
                TextMutationTask.Append,
                str: args[0] as! String);

            self.updateSelectionContext();

            message["result"] = "";
            self.apiControllerDelegate.postMessage(message);

        case "setSelectionRange":
            print("KeyboardWebAppInputMethodHandler: setSelectionRange not available on this platform.");

            message["error"] = "Unimplemented";
            self.apiControllerDelegate.postMessage(message);

        default:
            fatalError("KeyboardWebAppInputMethodHandler: Undefined method: \(method).")
        }

    }

    private func handleInputMethodManagerMessage(data: NSDictionary) {
        let method = data["method"] as! String;
        switch method {
            case "showAll":
                print("KeyboardWebAppInputMethodHandler: request showAll() but not available on this platform.");

            case "next":
                self.apiControllerDelegate.kbDelegate.advanceToNextInputMode();

            case "hide":
                self.apiControllerDelegate.kbDelegate.dismissKeyboard()

            default:
                fatalError("KeyboardWebAppInputMethodHandler: Undefined method: \(method).")
        }
    }

    private func handleInput(task: TextMutationTask, str: String = "", offset: Int = 0, length: Int = 0) {
        let textDocumentProxy: UITextDocumentProxy =
            self.apiControllerDelegate.kbDelegate.textDocumentProxy as UITextDocumentProxy;

        switch task {
        case .UpdateComposition:
            print("KeyboardWebAppInputMethodHandler: UpdateComposition not available on this platform. Composition: \(str)");

        case .Append:
            textDocumentProxy.insertText(str);

        case .Backspace:
            textDocumentProxy.deleteBackward();

        case .Return:
            textDocumentProxy.insertText("\n");

        case .Replace:
            textDocumentProxy.adjustTextPositionByCharacterOffset(offset + length);
            var i = 0;
            while i != length {
                textDocumentProxy.deleteBackward();
                i++;
            }
            textDocumentProxy.insertText(str);
        }
    }

    private func getSelectionInfo() -> NSDictionary {
        let textDocumentProxy : UITextDocumentProxy =
            self.apiControllerDelegate.kbDelegate.textDocumentProxy as UITextDocumentProxy;

        var textBeforeCursor = textDocumentProxy.documentContextBeforeInput;
        if (textBeforeCursor == nil) {
            textBeforeCursor = "";
        }

        var textAfterCursor = textDocumentProxy.documentContextAfterInput;
        if (textAfterCursor == nil) {
            textAfterCursor = "";
        }

        let charPosition = (textBeforeCursor! as NSString).length;

        print(textBeforeCursor);
        print(textAfterCursor);

        let info = NSMutableDictionary();
        info["selectionStart"] = charPosition;
        info["selectionEnd"] = charPosition; // XXX: No way to tell the selection range in iOS?
        info["textBeforeCursor"] = textBeforeCursor;
        info["textAfterCursor"] = textAfterCursor;

        return info;
    }
}