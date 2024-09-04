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
    func presentAlertFailedToCreateTask(error: String)
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
        let okAction = UIAlertAction(title: AppAssets.alertOkAction, style: .default)
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
    
    private func showAlertFailedToCreateTask(error: String) {
        let alertController = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AppAssets.alertOkAction, style: .default)
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
}

//MARK: TaskManagerViewProtocol
extension TaskManagerViewController: TaskManagerViewProtocol {
    func presentAlertFailedToCreateTask(error: String) {
        showAlertFailedToCreateTask(error: error)
    }
    
    func updateView(task: ToDo) {
        taskManagerView.configuration(title: task.title ?? "", description: task.description ?? "")
    }
    
    func presentIncompleteFieldsAlert() {
        showIncompleteFieldsAlert()
    }
}
