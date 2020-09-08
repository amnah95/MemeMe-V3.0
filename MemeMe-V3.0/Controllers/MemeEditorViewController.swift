//
//  MemeEditorViewController.swift
//  MemeMe-V1.0
//
//  Created by Amnah on 9/03/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, receiveData {
    
    
    // Variables and Outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imageViewPlaceHolder: UIImageView!
    
    var topTextClearFlag = true
    var bottomTextClearFlag = true
    
    let memeTextAttributes = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : NSNumber(value: -3.0 as Float)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
           
        setTextAttribute(topText, text: "TOP")
        setTextAttribute(bottomText, text:"BOTTOM")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable share button
        shareButton.isEnabled = false
        
        // Check if camera is avalible or not
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Subscribe to keyboared notification
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unubscribe from keyboared notification
        unsubscribeFromKeyboardNotifications()
        
    }
    
    // Conform to protocol
    func passData(meme: UIImage) {
        self.imageViewPlaceHolder.image = meme
        self.shareButton.isEnabled = true
    }

    
    //
    // Implementing all buttons' actions
    //
    
    // Prompts user to take new image
    @IBAction func imagePick(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if sender == cameraButton {
            imagePicker.sourceType = .camera
        }
        
        else {
        imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Prompts user to search new meme form network
    @IBAction func searchNewMeme(_ sender: Any) {
                
        let searchMemeViewController = self.storyboard!.instantiateViewController(withIdentifier: "NewtorkMemesCollectionViewController") as! NetworkMemesCollectionViewController
        
        searchMemeViewController.delegate = self
        
        present(searchMemeViewController, animated: true, completion: nil)
    }
    
    
    // Prompts user to take new image
    @IBAction func shareMeme (_ sender: Any) {
        let memedImage = generateMemedImage()

        let shareMemeViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareMemeViewController.completionWithItemsHandler = {
            (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.saveMeme(memedImageReceived: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }

        // to present imgae picker controller
        present(shareMemeViewController, animated: true, completion: nil)
    }
    
    
        
    // to cancel meme created
    @IBAction func cancelMeme (_ sender: Any) {
        let cancelMemeAlretContorller = UIAlertController()
        cancelMemeAlretContorller.title = "You are discarding the current meme."
        cancelMemeAlretContorller.message = "Do you want to continue?"
        
        // Sure action to continue with canceling
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }
        
        // No action button to stop canceling
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }
            // adding the two actions
            cancelMemeAlretContorller.addAction(yesAction)
            cancelMemeAlretContorller.addAction(noAction)
        // Presenting the alert view controller
        present(cancelMemeAlretContorller, animated: true, completion: nil)
    }
    
    
}

// MARL: ImagePicker methods
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    
    // implementing the image picker delegagte didFinishPickingMediaWithInfo function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let memeImage = info[.originalImage] as? UIImage {
            imageViewPlaceHolder.image = memeImage
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    // implementing the image picker delegagte imagePickerControllerDidCancel function
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: Meme generating and saving methods
extension MemeEditorViewController {
    
    // Implemeniting saving meme method
    func generateMemedImage() -> UIImage {

        //Hide toolbar and navbar
        toggleToolbar(toolbars: [topToolbar, bottomToolbar])

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        //Show toolbar and navbar
        toggleToolbar(toolbars: [topToolbar, bottomToolbar])

        return memedImage
    }
    
    // Hide/Unhide method
    func toggleToolbar (toolbars: [UIToolbar]) {
        toolbars.forEach { toolbar in
        toolbar.isHidden = !toolbar.isHidden
        }
    }
    
    // Impleminting Save meme function
    func saveMeme(memedImageReceived: UIImage) {
        
        let meme = UserMeme(context: DataController.shared.viewContext)
        meme.topText = topText.text
        meme.bottomText = bottomText.text
        meme.image = memedImageReceived.jpegData(compressionQuality: 1.0)
        meme.creationDate = Date()
        
        do {
            print("New meme added to database")
            try DataController.shared.viewContext.save()
        } catch {
            print("New meme was NOT added to database")
        }
    }
}


// MARK: Text feild delegates
extension MemeEditorViewController: UITextFieldDelegate {
    
    // Implementing attributes function
    func setTextAttribute(_ textField : UITextField, text : String) {
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    // implementing the text field delegagte textFieldDidBeginEditing function
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if  self.topTextClearFlag == true && textField == self.topText {
            self.topText.text = ""
            self.topTextClearFlag = false
            }
        if  self.bottomTextClearFlag == true && textField == self.bottomText {
            self.bottomText.text = ""
            self.bottomTextClearFlag = false
            }
    }
    
    // implementing the text field delegagte textFieldDidBeginEditing function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if  textField.text == "" && textField == self.topText {
            self.topText.text = "TOP"
        }
        if  textField.text == "" && textField == self.bottomText {
            self.bottomText.text = "BOTTOM"
        }
        textField.resignFirstResponder()
        return true
    }
}


// MARK: Keyboread notification methods
extension MemeEditorViewController {
    
    // Implementing keyboard notifications subscribe/unsubscribe methods
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {

        if bottomText.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}
