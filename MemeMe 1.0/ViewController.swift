//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Isaac To on 7/16/16.
//  Copyright © 2016 Isaac To. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController {

    // Mark: Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // Mark: Private attributes
    private let imagePickerController = UIImagePickerController()
    
    
    // MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    
    
}

