//
//  TaskManagerViewController.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import UIKit

protocol TaskManagerViewProtocol: AnyObject {
    func updateView(task: ToDo)
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
        presenter?.viewDidLoaded()
        handleButtonTapActions()
    }
    
    private func handleButtonTapActions() {
        doneButtonTapped()
        cancelButtonTapped()
    }
    
    private func doneButtonTapped() {
        taskManagerView.doneButtonAction = { [weak self] title, description in
            self?.presenter?.didTapDoneButton(title: title, description: description)
        }
    }
    
    private func cancelButtonTapped() {
        taskManagerView.cancelButtonAction = { [weak self] in
            self?.presenter?.didTapCancelButton()
        }
    }
}

//MARK: TaskManagerViewProtocol
extension TaskManagerViewController: TaskManagerViewProtocol {
    func updateView(task: ToDo) {
        guard let title = task.title, let description = task.description else {
            taskManagerView.configuration(title: "", description: "")
            return
        }
        taskManagerView.configuration(title: title, description: description)
    }
}
