//
//  ToDoPresenter.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import Foundation

protocol ToDoPresenterProtocol: AnyObject {
    func showTaskManagerModule(task: ToDo)
    func getTasks() -> [ToDo]
    func appendTask(task: ToDo)
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
    
    func appendTask(task: ToDo) {
        interactor.appendTask(task: task)
    }
    
    func showTaskManagerModule(task: ToDo) {
        router.showTaskManagerModule(task: task)
    }
    
    func getTasks() -> [ToDo] {
        return interactor.getTasks()
    }
}
