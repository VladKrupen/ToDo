//
//  TaskManagerInteractor.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import Foundation

protocol TaskManagerInteractorProtocol: AnyObject {
    func getResult() -> ToDo
    func didTapDoneButton(title: String, description: String)
}

final class TaskManagerInteractor {
    
    weak var presenter: TaskManagerPresenterProtocol?
    private var task: ToDo
    
    init(task: ToDo) {
        self.task = task
    }
    
    private func createTask(title: String, description: String) -> ToDo {
        let id = UUID().uuidString
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy\nHH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        let newTask = ToDo(id: id, title: title, description: description, completed: false, date: dateString)
        return newTask
    }
}

extension TaskManagerInteractor: TaskManagerInteractorProtocol {
    func getResult() -> ToDo {
        return task
    }
    
    func didTapDoneButton(title: String, description: String) {
        guard !title.isEmpty else {
            presenter?.presentIncompleteFieldsAlert()
            return
        }
        let newTask = createTask(title: title, description: description)
        presenter?.navigateToToDoModule(task: newTask)
    }
}
