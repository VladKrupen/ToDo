//
//  ToDoRouter.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

protocol ToDoRouterProtocol: AnyObject {
   func showTaskManagerModule()
}

final class ToDoRouter: ToDoRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func showTaskManagerModule() {
        let taskManagerViewController = ModuleFactory.createTaskManagerModule()
        viewController?.navigationController?.pushViewController(taskManagerViewController, animated: true)
    }
}
