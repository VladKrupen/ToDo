//
//  AppDelegate.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: CoreData stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print(error.localizedDescription)
            }
        }
    }
}

