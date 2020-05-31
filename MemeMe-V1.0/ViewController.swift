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

    // Prompts user to take new image
    @IBAction func takeNewImage(_ sender: UIButton) {
    }
        
    // Prompts user to pick image from album
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        //imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Prompts user to take new image
    @IBAction func shareMeme (_ sender: Any) {
        let memeImage = UIImage()
        let shareMemeViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        present(shareMemeViewController, animated: true, completion: nil)
    }
    
    // to cancel meme created
    @IBAction func cancelMeme (_ sender: Any) {
        let cancelMemeAlretContorller = UIAlertController()
        cancelMemeAlretContorller.title = "You are discarding current meme."
        cancelMemeAlretContorller.message = "Sure you want to continue?"
        
        let sureAction = UIAlertAction(title: "Sure", style: UIAlertAction.Style.default) { action in print("Sure is clicked")
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }
            cancelMemeAlretContorller.addAction(sureAction)
            cancelMemeAlretContorller.addAction(noAction)
        
        present(cancelMemeAlretContorller, animated: true, completion: nil)
        
    }
    
        
    }
    
//    func imagePickerController(_:didFinishPickingMediaWithInfo:)
//
//
//    func imagePickerControllerDidCancel(_:)
        
