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
    func updateTask(task: ToDo)
}

final class ToDoInteractor {
    
    weak var presenter: ToDoPresenterProtocol?
    private var tasks: [ToDo] = []
    
}

extension ToDoInteractor: ToDoInteractorProtocol {
    func getTasks() -> [ToDo] {
        return tasks
    }
    
    func appendTask(task: ToDo) {
        tasks.append(task)
    }
    
    func updateTask(task: ToDo) {
        var indexTask: Int?
        for (index, item) in tasks.enumerated() {
            if item.id == task.id {
                indexTask = index
            }
        }
        guard let indexTask = indexTask else {
            return
        }
        tasks[indexTask].completed = task.completed
    }
}
