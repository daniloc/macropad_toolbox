//
//  Persistence.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var previewObjectContext: NSManagedObjectContext {
        return Self.preview.container.viewContext
    }
    
    static var viewContext: NSManagedObjectContext {
        return Self.shared.container.viewContext
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<10 {
            let newItem = Configuration(context: viewContext)
            newItem.modificationDate = Date()
            newItem.name = "Configuration \(index)"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Macropad_Toolbox")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension NSManagedObjectContext {
    func attemptSaveLoggingErrors() {
        
        do {
            try save()
        } catch {
            print("⚠️ Error saving context:\n\(error)")
        }
        
    }
}
