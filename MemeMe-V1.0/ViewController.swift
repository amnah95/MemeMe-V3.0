//
//  ViewController.swift
//  MemeMe-V1.0
//
//  Created by Amnah on 5/30/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Variables and Outlets
    @IBOutlet weak var imageViewPlaceHolder: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Prompts the user to pick an image from the photo album
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        //imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
//    func imagePickerController(_:didFinishPickingMediaWithInfo:)
//
//
//    func imagePickerControllerDidCancel(_:)
        
    
}

