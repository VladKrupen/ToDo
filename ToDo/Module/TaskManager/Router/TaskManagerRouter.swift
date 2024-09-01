//
//  TaskManagerRouter.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import UIKit

protocol TaskManagerRouterProtocol: AnyObject {
    func dismissTaskManagerModule()
    func navigateToToDoModule(task: ToDo, action: UserAction)
}

final class TaskManagerRouter: TaskManagerRouterProtocol {
    
    weak var viewController: TaskManagerViewController?
    
    func dismissTaskManagerModule() {
        viewController?.dismiss(animated: true)
    }
    
    func navigateToToDoModule(task: ToDo, action: UserAction) {
        viewController?.todoTransferHandler?(task, action)
        viewController?.dismiss(animated: true)
    }
}
