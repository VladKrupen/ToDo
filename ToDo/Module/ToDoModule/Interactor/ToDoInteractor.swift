//
//  ToDoInteractor.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import Foundation

protocol ToDoInteractorProtocol: AnyObject {
    func getTasks() -> [ToDo]
    func appendTask(task: ToDo)
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
}

extension ToDoInteractor: ToDoInteractorProtocol {
    func getTasks() -> [ToDo] {
        return tasks
    }
    
    func appendTask(task: ToDo) {
        tasks.insert(task, at: 0)
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
