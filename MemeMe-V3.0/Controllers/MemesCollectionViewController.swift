//
//  MemesCollectionViewController.swift
//  MemeMe-V3.0
//
//  Created by Amnah on 9/03/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

class MemesCollectionViewController: UICollectionViewController {
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<UserMeme>!

    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let widthDimension = (view.frame.size.width - 2 * space ) / 3.0
        let heightDimension = (view.frame.size.width - 2 * space ) / 5.0
        
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupFetchResultsController()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style:.plain, target: self, action: #selector(createNewMeme))
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchResultsController()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // set fetched results controller to nil
        fetchedResultsController = nil
    }
    
    
    
    // Presenting the meme editor controller
    @objc func createNewMeme () {
        if let navigationController = navigationController {
            let memeEditorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
            
            memeEditorViewController.dataController = self.dataController
            memeEditorViewController.modalPresentationStyle = .fullScreen

            
            navigationController.present(memeEditorViewController, animated: true, completion: nil)
        }
        
    }

}

extension MemesCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    // Implement the number of collection cells method
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    // Implement populating cells method
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath) as! MemeCollectionViewCell
        
        let meme = fetchedResultsController.object(at: indexPath)
        
        cell.memeView?.image = UIImage(data: meme.image!)
        
        return cell
    }
    
    // Clicking on a cell function
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let viewMemeController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewerController") as! MemeViewerController
                        
        viewMemeController.memeToPresent = fetchedResultsController.object(at: indexPath)
        
        self.navigationController!.pushViewController(viewMemeController, animated: true)
    }
}


extension MemesCollectionViewController: NSFetchedResultsControllerDelegate {
    
    // Loading exsiting data in data base
    fileprivate func setupFetchResultsController() {
        
        print("Fetching Photos from data base")
        
        // Assign Fetch request first
        let fetchRequest: NSFetchRequest<UserMeme> = UserMeme.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Assign Fetch results controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "userMemes")
        
        // Set fectch controller delegate
        fetchedResultsController.delegate = self
        
        // Perform Fetch
        do {
            try fetchedResultsController.performFetch()
            print("Fetching is done, number of objects: \(fetchedResultsController.fetchedObjects?.count ?? 0)")
        } catch {
            print("The fetch could not be performed")
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print("NS Controller for insert")
        
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
            break
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        default:
            break
        }
    }
    
}
