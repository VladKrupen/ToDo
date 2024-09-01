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
    private let action: UserAction
    
    init(task: ToDo, action: UserAction) {
        self.task = task
        self.action = action
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
    
    private func checkAndHandleEmptyFields(title: String) -> Bool {
        guard !title.isEmpty else {
            presenter?.presentIncompleteFieldsAlert()
            return false
        }
        return true
    }
    
    private func manageTaskCreation(title: String, description: String) {
        guard checkAndHandleEmptyFields(title: title) else {
            return
        }
        let newTask = createTask(title: title, description: description)
        presenter?.navigateToToDoModule(task: newTask, action: action)
    }
    
    private func manageTaskEditing(title: String, description: String) {
        guard checkAndHandleEmptyFields(title: title) else {
            return
        }
        guard title != task.title || description != task.description else {
            presenter?.dismissTaskManagerModule()
            return
        }
        task.title = title
        task.description = description
        presenter?.navigateToToDoModule(task: task, action: action)
    }
}

extension TaskManagerInteractor: TaskManagerInteractorProtocol {
    func getResult() -> ToDo {
        return task
    }
    
    func didTapDoneButton(title: String, description: String) {
        switch action {
        case .buttonAction:
            manageTaskCreation(title: title, description: description)
        case .cellAction:
            manageTaskEditing(title: title, description: description)
        }
       
    }
}
