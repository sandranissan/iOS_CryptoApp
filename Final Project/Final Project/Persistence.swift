//
//  Persistence.swift
//  Final Project
//
//  Created by Hugo Leander on 2021-12-14.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "OwnedCrypto")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("fel med container + \(error)")
            }
        }
    }
    
    func save() {
        let viewContext = container.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("fel med save + \(error)")
            }
        }
    }
    
    func sellCrypto(owned: OwnedCrypto) {
        container.viewContext.delete(owned)
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            
        }
    }
}
