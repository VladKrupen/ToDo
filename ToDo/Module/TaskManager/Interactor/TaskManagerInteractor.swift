//
//  TaskManagerInteractor.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import Foundation

protocol TaskManagerInteractorProtocol: AnyObject {
    
}

final class TaskManagerInteractor {
    
    weak var presenter: TaskManagerPresenterProtocol?
    
}

extension TaskManagerInteractor: TaskManagerInteractorProtocol {
    
}
