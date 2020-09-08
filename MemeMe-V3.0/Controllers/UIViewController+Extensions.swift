//
//  UIViewController+Extensions.swift
//  MemeMe-V3.0
//
//  Created by Amnah on 9/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setUpNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style:.plain, target: self, action: #selector(createNewMeme))
    }
    
    // Presenting the meme editor controller
     @objc func createNewMeme () {
        if navigationController == navigationController {
            
            let memeEditorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
                  
            memeEditorViewController.modalPresentationStyle = .fullScreen
            
            
            present(memeEditorViewController, animated: true, completion: nil)

        }
    }
    
    func setUpCollectionViewFlow(flowLayout: UICollectionViewFlowLayout, view: UIView) {
        let space: CGFloat = 3.0
        let widthDimension = (view.frame.size.width - 2 * space ) / 3.0
        let heightDimension = (view.frame.size.width - 2 * space ) / 5.0
        
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
}


// MARK: To pass data between controllers
protocol receiveData {
  func passData(meme: UIImage)
}
