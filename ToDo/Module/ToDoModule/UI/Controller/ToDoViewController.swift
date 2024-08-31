//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

protocol ToDoViewProtocol: AnyObject {
    
}

final class ToDoViewController: UIViewController {
    
    //MARK: Public
    var presenter: ToDoPresenterProtocol?
    
    //MARK: Private
    private let toDoView = ToDoView()
    
    //MARK: View lifecycle
    override func loadView() {
        super.loadView()
        view = toDoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoView.setupDelegateAndDataSource(delegate: self, dataSource: self)
        setupNavigationItem()
    }
    
    //MARK: Setup
    private func setupNavigationItem() {
        navigationItem.title = AppAssets.navigationItemTitle
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: AppAssets.navigationItemButtonImage), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

//MARK: OBJC
extension ToDoViewController {
    @objc private func rightBarButtonTapped() {
        let task = ToDo()
        presenter?.showTaskManagerModule(task: task)
    }
}

//MARK: ToDoViewProtocol
extension ToDoViewController: ToDoViewProtocol {
    
}

//MARK: UITableViewDataSource
extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ToDoCell.self), for: indexPath) as? ToDoCell else {
            return UITableViewCell()
        }
        cell.setupCell(bool: false)
        cell.checkmarkImageViewAction = { [weak self] bool in
            
        }
        return cell
    }
}

//MARK: UITableViewDelegate
extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionsConfiguration
    }
}
