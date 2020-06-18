//
//  MemeViewerController.swift
//  MemeMe-V2.0
//
//  Created by Amnah on 6/10/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeViewerController: UIViewController {
    
    var memeToPresent: Meme!
    
    @IBOutlet weak var memeViewer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeViewer.image = memeToPresent.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
