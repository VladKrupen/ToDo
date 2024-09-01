//
//  TaskManagerPresenter.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import Foundation

protocol TaskManagerPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didTapDoneButton(title: String, description: String)
    func dismissTaskManagerModule()
    func presentIncompleteFieldsAlert()
    func navigateToToDoModule(task: ToDo, action: UserAction)
}

final class TaskManagerPresenter {
    
    weak var view: TaskManagerViewProtocol?
    let interactor: TaskManagerInteractorProtocol
    let router: TaskManagerRouterProtocol
    
    init(view: TaskManagerViewProtocol? = nil, interactor: TaskManagerInteractorProtocol, router: TaskManagerRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TaskManagerPresenter: TaskManagerPresenterProtocol {
    func navigateToToDoModule(task: ToDo, action: UserAction) {
        router.navigateToToDoModule(task: task, action: action)
    }
    
    func didTapDoneButton(title: String, description: String) {
        interactor.didTapDoneButton(title: title, description: description)
    }
    
    func dismissTaskManagerModule() {
        router.dismissTaskManagerModule()
    }
    
    func presentIncompleteFieldsAlert() {
        view?.presentIncompleteFieldsAlert()
    }
    
    func viewDidLoaded() {
        let task = interactor.getResult()
        view?.updateView(task: task)
    }
}
