//
//  ToDoPresenter.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import Foundation

protocol ToDoPresenterProtocol: AnyObject {
    func showTaskManagerModule(task: ToDo, action: UserAction)
    func getTasks() -> [ToDo]
    func updateTasks(task: ToDo, action: UserAction)
    func updateTaskReadinessStatus(task: ToDo)
    func deleteTask(task: ToDo)
}

final class ToDoPresenter {
    
    weak var view: ToDoViewProtocol?
    let interactor: ToDoInteractorProtocol
    let router: ToDoRouterProtocol
    
    init(view: ToDoViewProtocol? = nil, interactor: ToDoInteractorProtocol, router: ToDoRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ToDoPresenter: ToDoPresenterProtocol {
    func deleteTask(task: ToDo) {
        interactor.deleteTask(task: task)
    }
    
    func updateTaskReadinessStatus(task: ToDo) {
        interactor.updateTaskReadinessStatus(task: task)
    }
    
    func updateTasks(task: ToDo, action: UserAction) {
        interactor.updateTasks(task: task, action: action)
    }
    
    func showTaskManagerModule(task: ToDo, action: UserAction) {
        router.showTaskManagerModule(task: task, action: action)
    }
    
    func getTasks() -> [ToDo] {
        return interactor.getTasks()
    }
}
