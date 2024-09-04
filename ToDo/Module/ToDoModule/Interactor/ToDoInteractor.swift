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
    func getCurrentDate() -> Date
}

final class ToDoInteractor {
    
    weak var presenter: ToDoPresenterProtocol?
    private let uninstallManager: TaskDeletionProtocol
    private let updateManager: TaskUpdateProtocol
    private let readingManager: TaskReadingProtocol
    private let creationManager: TaskCreationProtocol
    private let networkManager: NetworkManagerProtocol
    private let userDefaultsManager: TaskLoadingStatusProtocol
    private var tasks: [ToDo] = []
    
    init(uninstallManager: TaskDeletionProtocol, updateManager: TaskUpdateProtocol, readingManager: TaskReadingProtocol, creationManager: TaskCreationProtocol, networkManager: NetworkManagerProtocol, userDefaultsManager: TaskLoadingStatusProtocol) {
        self.uninstallManager = uninstallManager
        self.updateManager = updateManager
        self.readingManager = readingManager
        self.creationManager = creationManager
        self.networkManager = networkManager
        self.userDefaultsManager = userDefaultsManager
    }
    
    private func getTasksFromCoreData() {
        readingManager.readTasks { [weak self] tasks in
            guard let tasks = tasks else {
                return
            }
            self?.presenter?.updateView(tasks: tasks)
        }
    }
}

extension ToDoInteractor: ToDoInteractorProtocol {
    func getCurrentDate() -> Date {
        return Date()
    }
    
    func getTasks() {
        guard userDefaultsManager.areTasksLoadedFromNetwork() else {
            self.networkManager.fetchTasks { [weak self] result in
                switch result {
                case .success(let data):
                    
                    //DispatchGroup
                    data.forEach { self?.creationManager.createTask(task: $0) {
                        
                    } }
                    self?.getTasksFromCoreData()
                    self?.userDefaultsManager.updateTasksLoadedStatus()
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self?.getTasksFromCoreData()
                    }
                }
            }
            return
        }
        getTasksFromCoreData()
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
