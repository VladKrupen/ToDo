//
//  ToDoInteractor.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import Foundation

protocol ToDoInteractorProtocol: AnyObject {
    
}

final class ToDoInteractor {
    
    weak var presenter: ToDoPresenterProtocol?
    
}

extension ToDoInteractor: ToDoInteractorProtocol {
    
}
