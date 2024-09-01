//
//  ToDoInteractor.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import Foundation

protocol ToDoInteractorProtocol: AnyObject {
    func getTasks() -> [ToDo]
    func updateTasks(task: ToDo, action: UserAction)
    func updateTaskReadinessStatus(task: ToDo)
    func deleteTask(task: ToDo)
}

final class ToDoInteractor {
    
    weak var presenter: ToDoPresenterProtocol?
    private var tasks: [ToDo] = []
    
    private func findIdTask(id: String?) -> Int? {
        var indexTask: Int?
        for (index, task) in tasks.enumerated() {
            if task.id == id {
                indexTask = index
            }
        }
        guard let indexTask = indexTask else {
            return nil
        }
        return indexTask
    }
    
    private func appendTask(task: ToDo) {
        tasks.insert(task, at: 0)
    }
    
    private func changeTask(task: ToDo) {
        guard let id = findIdTask(id: task.id) else {
            return
        }
        tasks[id] = task
    }
}

extension ToDoInteractor: ToDoInteractorProtocol {
    func getTasks() -> [ToDo] {
        return tasks
    }
    
    func updateTasks(task: ToDo, action: UserAction) {
        switch action {
        case .buttonAction:
            appendTask(task: task)
        case .cellAction:
            changeTask(task: task)
        }
    }
    
    func updateTaskReadinessStatus(task: ToDo) {
        guard let id = findIdTask(id: task.id) else {
            return
        }
        tasks[id].completed = task.completed
    }
    
    func deleteTask(task: ToDo) {
        guard let id = findIdTask(id: task.id) else {
            return
        }
        tasks.remove(at: id)
    }
}
