//
//  PersistenceController.swift
//  HWYU
//
//  Created by Yungui Lee on 8/6/24.
//

import Foundation
import CoreData
import CloudKit
import SwiftUI

let gCloudKitContainerIdentifier = "iCloud.me.iyungui.HWYU"

class PersistenceController {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ShareLogs")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
