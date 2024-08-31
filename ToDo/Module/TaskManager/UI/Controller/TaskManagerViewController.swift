//
//  TaskManagerViewController.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import UIKit

protocol TaskManagerViewProtocol: AnyObject {
    
}

final class TaskManagerViewController: UIViewController {
    
    //MARK: Public
    var presenter: TaskManagerPresenterProtocol?
    
    //MARK: Private
    private let taskManagerView = TaskManagerView()
    
    //MARK: View lifecycle
    override func loadView() {
        super.loadView()
        view = taskManagerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskManagerView.configuration(title: "Задача", description: "Описание")
    }
}

//MARK: TaskManagerViewProtocol
extension TaskManagerViewController: TaskManagerViewProtocol {
    
}
