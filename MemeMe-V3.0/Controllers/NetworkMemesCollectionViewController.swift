//
//  NetworkMemesCollectionViewController.swift
//  MemeMe-V3.0
//
//  Created by Amnah on 9/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class NetworkMemesCollectionViewController: UIViewController, UICollectionViewDelegate {
    
    var memesFound: [UIImage] = []
    var delegate: receiveData? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpCollectionViewFlow(flowLayout: self.flowLayout, view: view)
        getMemesData()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
        
}

// MARK: Collection View controller data source
extension NetworkMemesCollectionViewController: UICollectionViewDataSource {
    
    // Implement the number of collection cells method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memesFound.count
    }
    
    // Implement populating cells method
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath) as! MemeCollectionViewCell
        
        let meme = self.memesFound[(indexPath as NSIndexPath).row]
        
        cell.memeView.image = meme
        
        cell.photoLoadingIndicator.stopAnimating()
        
        return cell
    }
    
    // Clicking on a cell function
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        print("image is there \(self.memesFound[(indexPath as NSIndexPath).row].isKind(of: UIImage.self))")
        
        
        delegate!.passData(meme: self.memesFound[(indexPath as NSIndexPath).row])

        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: Download meme collection from newtork
extension NetworkMemesCollectionViewController {
    
    // Get photos data from network
    func getMemesData() {
        
        self.loadingIndicator.startAnimating()

        
        var memesList: [MemeData] = []
                
        _ = Client.getMemes(completion: { (results, error) in
            
            if error != nil {
                self.networkAlret()
            }
            
            self.loadingIndicator.stopAnimating()
            memesList = results

            for meme in memesList {
                Client.requestImageFile(meme.memeURL()) { (data, error) in
                    guard let memeData = data else { return }
                    self.memesFound.append(UIImage(data: memeData)!)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        })
    }
}


//MARK: Network Alret
extension NetworkMemesCollectionViewController {
    
    func networkAlret () {
        let networkAlretContorller = UIAlertController(title: "Failed to Connect to network", message: "Do you want to try again?", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default) { action in self.getMemesData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }
        
        // adding the two actions
        networkAlretContorller.addAction(retryAction)
        networkAlretContorller.addAction(cancelAction)
        // Presenting the alert view controller
        present(networkAlretContorller, animated: true, completion: nil)
    }
}
    

