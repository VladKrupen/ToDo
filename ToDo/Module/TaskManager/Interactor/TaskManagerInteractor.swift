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
}

extension TaskManagerInteractor: TaskManagerInteractorProtocol {
    func getResult() -> ToDo {
        return task
    }
    
    func didTapDoneButton(title: String, description: String) {
        guard !title.isEmpty else {
            return
        }
    }
}
