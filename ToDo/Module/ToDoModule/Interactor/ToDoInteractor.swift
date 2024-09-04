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
    private let uninstallManager: TaskDeletion
    private let updateManager: TaskUpdate
    private let readingManager: TaskReading
    private let creationManager: TaskCreation
    private let networkManager: NetworkManagerProtocol
    private let userDefaultsManager: TaskLoadingStatusProtocol
    private var tasks: [ToDo] = []
    
    init(uninstallManager: TaskDeletion, updateManager: TaskUpdate, readingManager: TaskReading, creationManager: TaskCreation, networkManager: NetworkManagerProtocol, userDefaultsManager: TaskLoadingStatusProtocol) {
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
    
    private func addTheReceivedDataToTheCoreData(data: [ToDo]) {
        let dispatchGroup = DispatchGroup()
        for task in data {
            dispatchGroup.enter()
            creationManager.createTask(task: task, completion: { [weak self] error in
                guard error == nil else {
                    dispatchGroup.leave()
                    return
                }
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.getTasksFromCoreData()
            self?.userDefaultsManager.updateTasksLoadedStatus()
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
                    self?.addTheReceivedDataToTheCoreData(data: data)
                case .failure(let error):
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
