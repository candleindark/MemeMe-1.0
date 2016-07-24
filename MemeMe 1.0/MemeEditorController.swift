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
    @IBOutlet private weak var memeDisplay: UIView!
    
    // Mark: Private attributes
    private let imagePickerController = UIImagePickerController()
    private var adjustedForKeyboard = false
    private let topTextFieldDelegate = TextFieldDelegate()
    private let bottomTextFieldDelegate = TextFieldDelegate()
    
    // MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(),
                              NSForegroundColorAttributeName : UIColor.whiteColor(),
                              NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                              NSStrokeWidthAttributeName : NSNumber(double: -3.0)]
        
        // Set placeholders of textfields
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: textAttributes)
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: textAttributes)
        
        // Set default text attributes of textfields
        topTextField.defaultTextAttributes = textAttributes
        bottomTextField.defaultTextAttributes = textAttributes
        
        // Set delegates of textfields
        topTextField.delegate = topTextFieldDelegate
        bottomTextField.delegate = bottomTextFieldDelegate
        
        imagePickerController.delegate = self   // Set delegate of image picker
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        // Enable/disable buttons depending on available resources
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        albumButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Actions
    @IBAction private func selectPhoto(sender: UIBarButtonItem) {
        // Set image picker to the selected source type
        if sender == cameraButton {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction private func shareMeme() {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            activityType, completed, returnedItems, activityError in
            
            if completed {
                self.saveMeme(memedImage)
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func clearMeme(sender: UIBarButtonItem) {
        imageView.image = nil
        topTextField.text = nil
        bottomTextField.text = nil
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
        
        let isCurrentAppKeyboard = notification.userInfo![UIKeyboardIsLocalUserInfoKey] as! NSNumber    // Indicate if the keyboard belongs to the app
        
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
        let isCurrentAppKeyboard = notification.userInfo![UIKeyboardIsLocalUserInfoKey] as! NSNumber    // Indicate if the keyboard belongs to the app
        
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
    
    private func generateMemedImage() -> UIImage {
        // Render image
        UIGraphicsBeginImageContext(memeDisplay.frame.size)
        memeDisplay.drawViewHierarchyInRect(CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: memeDisplay.frame.size), afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    private func saveMeme(memedImage: UIImage) {
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
}

