//
//  CoreDataManager.swift
//  ToDo
//
//  Created by Vlad on 2.09.24.
//

import UIKit
import CoreData

protocol TaskCreationProtocol: AnyObject {
    func createTask(task: ToDo, completion: @escaping () -> Void)
}

protocol TaskReadingProtocol: AnyObject {
    func readTasks(completion: @escaping ([ToDo]?) -> Void)
}

protocol TaskUpdateProtocol: AnyObject {
    func updateTask(task: ToDo, completion: @escaping () -> Void)
}

protocol TaskDeletionProtocol: AnyObject {
    func deleteTask(task: ToDo, completion: @escaping () -> Void)
}

final class CoreDataManager: TaskCreationProtocol, TaskReadingProtocol, TaskUpdateProtocol, TaskDeletionProtocol {
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func createTask(task: ToDo, completion: @escaping () -> Void) {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = context
        DispatchQueue.global(qos: .userInitiated).async {
            let newTask = Task(context: privateContext)
            newTask.id = task.id
            newTask.title = task.title
            newTask.taskDescription = task.description
            newTask.completed = task.completed ?? false
            newTask.date = task.date
            do {
                try privateContext.save()
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error when saving task: \(error)")
            }
        }
    }
    
    func readTasks(completion: @escaping ([ToDo]?) -> Void) {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = context
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchRequest = Task.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                let tasks = try privateContext.fetch(fetchRequest)
                let todos = tasks.map { ToDo(task: $0) }
                DispatchQueue.main.async {
                    completion(todos)
                }
            } catch {
                print("Error when receiving tasks: \(error)")
                completion(nil)
            }
        }
    }
    
    func updateTask(task: ToDo, completion: @escaping () -> Void) {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = context
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchRequest = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id!)
            do {
                let databaseTasks = try privateContext.fetch(fetchRequest)
                guard let databaseTask = databaseTasks.first else {
                    return
                }
                databaseTask.title = task.title
                databaseTask.taskDescription = task.description
                databaseTask.completed = task.completed!
                do {
                    try privateContext.save()
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Error when updating task: \(error)")
                }
            } catch {
                print("Error when receiving tasks: \(error)")
            }
        }
        
    }
    
    func deleteTask(task: ToDo, completion: @escaping () -> Void) {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = context
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchRequest = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id!)
            do {
                let databaseTasks = try privateContext.fetch(fetchRequest)
                guard let databaseTask = databaseTasks.first else {
                    return
                }
                privateContext.delete(databaseTask)
                do {
                    try privateContext.save()
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Error when deleting task: \(error)")
                }
            } catch {
                print("Error when receiving tasks: \(error)")
            }
        }
    }
}
