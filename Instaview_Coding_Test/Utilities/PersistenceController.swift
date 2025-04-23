//
//  UnsplashImageApp.swift
//  Instaview_Coding_Test
//
//  Created by Prashant Tiwari on 23/04/25.
//

import SwiftUI
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "ImageCoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed: \(error.localizedDescription)")
            }
        }
    }
}
