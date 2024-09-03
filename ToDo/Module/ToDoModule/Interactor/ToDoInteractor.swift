//
//  ToDoInteractor.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import Foundation

protocol ToDoInteractorProtocol: AnyObject {
    func getTasks()
    func updateTaskReadinessStatus(task: ToDo)
    func deleteTask(task: ToDo)
}

final class ToDoInteractor {
    
    weak var presenter: ToDoPresenterProtocol?
    private let uninstallManager: TaskDeletionProtocol
    private let updateManager: TaskUpdateProtocol
    private let readingManager: TaskReadingProtocol
    private var tasks: [ToDo] = []
    
    init(uninstallManager: TaskDeletionProtocol, updateManager: TaskUpdateProtocol, readingManager: TaskReadingProtocol) {
        self.uninstallManager = uninstallManager
        self.updateManager = updateManager
        self.readingManager = readingManager
    }
}

extension ToDoInteractor: ToDoInteractorProtocol {
    func getTasks() {
        readingManager.readTasks { [weak self] tasks in
            guard let tasks = tasks else {
                return
            }
            self?.presenter?.updateView(tasks: tasks)
        }
    }
    
    func updateTaskReadinessStatus(task: ToDo) {
        updateManager.updateTask(task: task) {
            
        }
    }
    
    func deleteTask(task: ToDo) {
        uninstallManager.deleteTask(task: task) {
            
        }
    }
}
