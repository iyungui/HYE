//
//  PersistenceController.swift
//  HWYU
//
//  Created by Yungui Lee on 7/25/24.
//

import CoreData

class PersistenceController {
    static let shared = NSPersistentContainer()
    
    let container: NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "ShareLogs")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Container load failed: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

/*
 struct PersistenceController {
     static let shared = PersistenceController()
     
     let container: NSPersistentCloudKitContainer
     
     init() {
         container = NSPersistentCloudKitContainer(name: "Products")
         container.loadPersistentStores { (storeDescription, error) in
             if let error = error as NSError? {
                 fatalError("Container load failed: \(error)")
             }
         }
         container.viewContext.automaticallyMergesChangesFromParent = true
     }
 }

 */
