//
//  ToDoPresenter.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import Foundation

protocol ToDoPresenterProtocol: AnyObject {
    
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
   
}
