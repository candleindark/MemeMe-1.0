//
//  TextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by Isaac To on 7/23/16.
//  Copyright © 2016 Isaac To. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var attributedPlaceholder: NSAttributedString?  // For storing the attributed placeholder of a textfield
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        attributedPlaceholder = textField.attributedPlaceholder
        textField.attributedPlaceholder = nil   // Clear the textfield of its placeholder
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.attributedPlaceholder = attributedPlaceholder // Restore the placeholder of the textfield
        attributedPlaceholder = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()    // Dismiss the keyboard
        return true
    }
}