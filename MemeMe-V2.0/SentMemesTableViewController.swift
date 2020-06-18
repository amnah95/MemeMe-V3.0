//
//  SentMemesTableViewController.swift
//  MemeMe-V2.0
//
//  Created by Amnah on 6/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class sentMemesTableViewController: UITableViewController {
    
    //var memes: [Meme] = []
    
    // Computed variable of the saved memes
    var memes: [Meme]! {
        return MemesLibrary.shared.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style:.plain, target: self, action: #selector(createNewMeme))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    // Presenting the meme editor controller
    @objc func createNewMeme () {
        if let navigationController = navigationController {
            
            let memeViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
                  
            memeViewController.modalPresentationStyle = .fullScreen
            
            present(memeViewController, animated: true, completion: nil)

        }
    }
    
    // 1- Impelement number of rows method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    

    
    // 2- Implement the cell population method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCellID)!
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText + " ... " + meme.bottomText
        cell.imageView?.image = meme.memedImage
                
        return cell
    }
    
    // 3- Implement the row selection method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewMemeController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewerController") as! MemeViewerController
                        
        viewMemeController.memeToPresent = memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(viewMemeController, animated: true)
        
    }
    

}
    
    

