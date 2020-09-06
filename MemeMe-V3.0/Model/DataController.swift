//
//  DataController.swift
//  MemeMe-V3.0
//
//  Created by Amnah on 9/3/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import CoreData


class DataController {
    
    static let shared = DataController(modelName: "MemeMe-V3.0")
        
    // This will remain unchanged for the entire app
    let persistentContainer: NSPersistentContainer!
    
    // The constructer for this class, required because we have a constant
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    // ViewContext will be updated regulerly
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Load persistent stoers related to our container
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
}
