//
//  PersistenceController.swift
//  HWYU
//
//  Created by Yungui Lee on 7/25/24.
//

import Foundation
import CoreData
import CloudKit
import SwiftUI

let gCloudKitContainerIdentifier = "iCloud.me.iyungui.HWYU"

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
