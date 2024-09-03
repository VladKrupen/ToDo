//
//  ModuleFactory.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

final class ModuleFactory {
    static func createToDoModule() -> ToDoViewController {
        let coreDataManager = CoreDataManager()
        let viewController = ToDoViewController()
        let interactor = ToDoInteractor(uninstallManager: coreDataManager, updateManager: coreDataManager, readingManager: coreDataManager)
        let router = ToDoRouter()
        let presenter = ToDoPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        router.presenter = presenter
        return viewController
    }
    
    static func createTaskManagerModule(task: ToDo, action: UserAction) -> TaskManagerViewController {
        let coreDataManager = CoreDataManager()
        let viewController = TaskManagerViewController()
        let interactor = TaskManagerInteractor(task: task, action: action, updateManager: coreDataManager, creationManager: coreDataManager)
        let router = TaskManagerRouter()
        let presenter = TaskManagerPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
