//
//  MemesTableViewController.swift
//  MemeMe-V3.0
//
//  Created by Amnah on 9/03/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

class MemesTableViewController: UITableViewController {
        
    var fetchedResultsController: NSFetchedResultsController<UserMeme>!

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupFetchResultsController()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchResultsController()
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // set fetched results controller to nil
        fetchedResultsController = nil
    }
    
}


// MARK: Table view controller data source
extension MemesTableViewController {
    
//    // Impelement number of section method
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultsController.sections?.count ?? 1
//    }
    
    // Impelement number of rows method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    // Implement the cell population method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aUserMeme = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCellID)!
                
        cell.textLabel?.text = aUserMeme.topText! + " ... " + aUserMeme.bottomText!
        cell.imageView?.image = UIImage(data: aUserMeme.image!)
                
        return cell
    }
    
    // Implement the row selection method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewMemeController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewerController") as! MemeViewerController
        
        viewMemeController.memeToPresent = fetchedResultsController.object(at: indexPath)
        
        self.navigationController!.pushViewController(viewMemeController, animated: true)
        
    }
}
    
    

// MARK: Fetch results controller
extension MemesTableViewController: NSFetchedResultsControllerDelegate {
    
    // Loading exsiting data in data base
    fileprivate func setupFetchResultsController() {
        
        print("Fetching Photos from data base")
        
        // Assign Fetch request first
        let fetchRequest: NSFetchRequest<UserMeme> = UserMeme.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Assign Fetch results controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "userMemes")
        
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
                
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
            break
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


//MARK: Helper methods
extension MemesTableViewController{
    
    fileprivate func setUpNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style:.plain, target: self, action: #selector(createNewMeme))
    }
    
    // Presenting the meme editor controller
    @objc fileprivate func createNewMeme () {
        if navigationController == navigationController {
            
            let memeEditorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
                  
            memeEditorViewController.modalPresentationStyle = .fullScreen
            
            
            present(memeEditorViewController, animated: true, completion: nil)

        }
    }
}
