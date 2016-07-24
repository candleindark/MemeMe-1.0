//
//  TextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by Isaac To on 7/23/16.
//  Copyright © 2016 Isaac To. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var attributedPlaceholder: NSAttributedString?
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        attributedPlaceholder = textField.attributedPlaceholder
        textField.attributedPlaceholder = nil
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.attributedPlaceholder = attributedPlaceholder
        attributedPlaceholder = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}