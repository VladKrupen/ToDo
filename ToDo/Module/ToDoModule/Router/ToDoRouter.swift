//
//  ToDoRouter.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

protocol ToDoRouterProtocol: AnyObject {
    func showTaskManagerModule(task: ToDo, action: UserAction)
}

final class ToDoRouter: ToDoRouterProtocol {
    
    weak var viewController: ToDoViewController?
    var presenter: ToDoPresenterProtocol?
    
    func showTaskManagerModule(task: ToDo, action: UserAction) {
        let taskManagerViewController = ModuleFactory.createTaskManagerModule(task: task, action: action)
        taskManagerViewController.modalPresentationStyle = .fullScreen
        viewController?.present(taskManagerViewController, animated: true)
        taskManagerViewController.todoTransferHandler = { [weak self] task, action in
            self?.presenter?.updateTasks(task: task, action: action)
        }
    }
}
