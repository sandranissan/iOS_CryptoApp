//
//  CoreDataTestStack.swift
//  Final Project
//
//  Created by Hugo Leander on 2021-12-15.
//



import CoreData


/*
 This is the CoreDataManager used by tests. It saves nothing to disk. All in-memory.
 When setting up tests authors can choose the queues they would like to operate on.
 - `mainContext` with interacts on the main UI thread, or
 - `backgroundContext` with has a separate queue for background processing
 Note: This can't be a shared singleton. Else tests would collide with each other.
 */
struct CoreDataTestStack {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourDataStore")
        
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load stores: \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
}
