//
//  TaskManagerPresenter.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import Foundation

protocol TaskManagerPresenterProtocol: AnyObject {
    
}

final class TaskManagerPresenter {
    
    weak var view: TaskManagerViewProtocol?
    let interactor: TaskManagerInteractorProtocol
    
    init(view: TaskManagerViewProtocol? = nil, interactor: TaskManagerInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
}

extension TaskManagerPresenter: TaskManagerPresenterProtocol {
    
}
