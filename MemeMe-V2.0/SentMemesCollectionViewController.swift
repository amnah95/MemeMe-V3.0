//
//  SentMemesCollectionViewController.swift
//  MemeMe-V2.0
//
//  Created by Amnah on 6/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class sentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // Computed variable of the saved memes
    var memes: [Meme]! {
        return MemesLibrary.shared.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let widthDimension = (view.frame.size.width - 2 * space ) / 3.0
        let heightDimension = (view.frame.size.width - 2 * space ) / 5.0
        
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style:.plain, target: self, action: #selector(createNewMeme))
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // Presenting the meme editor controller
    @objc func createNewMeme () {
        if let navigationController = navigationController {
            let memeViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
            
            memeViewController.modalPresentationStyle = .fullScreen

            
            navigationController.present(memeViewController, animated: true, completion: nil)
        }
        
    }
    
    // 1- Implement the number of collection cells method
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    // 2- Implement populating cells method
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath) as! MemeCollectionViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.memeView?.image = meme.memedImage
        
        return cell
    }
    
    //3- Clicking on a cell function
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let viewMemeController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewerController") as! MemeViewerController
                        
        viewMemeController.memeToPresent = memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(viewMemeController, animated: true)
    }

}
