//
//  TaskManagerViewController.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import UIKit

protocol TaskManagerViewProtocol: AnyObject {
    func updateView(task: ToDo)
    func presentIncompleteFieldsAlert()
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
            self?.presenter?.dismissTaskManagerModule()
        }
    }
    
    private func showIncompleteFieldsAlert() {
        let alertController = UIAlertController(title: nil, message: AppAssets.alertEmptyFieldsMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AppAssets.alertEmptyFieldsAction, style: .default)
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
}

//MARK: TaskManagerViewProtocol
extension TaskManagerViewController: TaskManagerViewProtocol {
    func updateView(task: ToDo) {
        taskManagerView.configuration(title: task.title ?? "", description: task.description ?? "")
    }
    
    func presentIncompleteFieldsAlert() {
        showIncompleteFieldsAlert()
    }
}
