//
//  ToDoRouter.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

protocol ToDoRouterProtocol: AnyObject {
    func showTaskManagerModule(task: ToDo)
}

final class ToDoRouter: ToDoRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func showTaskManagerModule(task: ToDo) {
        let taskManagerViewController = ModuleFactory.createTaskManagerModule(task: task)
        taskManagerViewController.modalPresentationStyle = .fullScreen
        viewController?.present(taskManagerViewController, animated: true)
    }
}
