//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Isaac To on 7/16/16.
//  Copyright © 2016 Isaac To. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Mark: Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var cameraButton: UIBarButtonItem!
    @IBOutlet private weak var albumButton: UIBarButtonItem!
    @IBOutlet private weak var topTextField: UITextField!
    @IBOutlet private weak var bottomTextField: UITextField!
    
    // Mark: Private attributes
    private let imagePickerController = UIImagePickerController()
    private var adjustedForKeyboard = false
    
    
    // MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePickerController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        albumButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Actions
    @IBAction func selectPhoto(sender: UIBarButtonItem) {
        if sender == cameraButton {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Other methods
    private func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let isCurrentAppKeyboard = notification.userInfo![UIKeyboardIsLocalUserInfoKey] as! NSNumber
        
        if isCurrentAppKeyboard.boolValue { // The given keyboard belongs to the app
            if bottomTextField.isFirstResponder() {
                if !adjustedForKeyboard {
                    view.frame.origin.y -= getKeyboardHeight(notification)
                    adjustedForKeyboard = true
                }
            } else {
                adjustForKeyboardRemovalIfNeeded(notification)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let isCurrentAppKeyboard = notification.userInfo![UIKeyboardIsLocalUserInfoKey] as! NSNumber
        
        if isCurrentAppKeyboard.boolValue {
            adjustForKeyboardRemovalIfNeeded(notification)
        }
    }
    
    private func adjustForKeyboardRemovalIfNeeded(notification: NSNotification) {
        if adjustedForKeyboard {
            view.frame.origin.y += getKeyboardHeight(notification)
            adjustedForKeyboard = false
        }
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue    // of CGRect
        return keyboardSize.CGRectValue().height
    }
}

