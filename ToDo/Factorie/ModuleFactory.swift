//
//  ModuleFactory.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

final class ModuleFactory {
    static func createToDoModule() -> ToDoViewController {
        let viewController = ToDoViewController()
        let interactor = ToDoInteractor()
        let router = ToDoRouter()
        let presenter = ToDoPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
    
    static func createTaskManagerModule() -> TaskManagerViewController {
        let viewController = TaskManagerViewController()
        let interactor = TaskManagerInteractor()
        let presenter = TaskManagerPresenter(view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.presenter = presenter
        return viewController
    }
}
