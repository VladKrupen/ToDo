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
    var tasks: [ToDo] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let result = presenter?.getTasks() else {
            return
        }
        tasks = result
        reloadData()
    }
    
    //MARK: Setup
    func reloadData() {
        toDoView.reloadData()
    }
    
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
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ToDoCell.self), for: indexPath) as? ToDoCell else {
            return UITableViewCell()
        }
        var task = tasks[indexPath.row]
        cell.setupCell(title: task.title!, date: task.date!, description: task.description!, bool: task.completed!)
        cell.checkmarkImageViewAction = { [weak self] bool in
            task.completed = bool
            self?.presenter?.updateTaskReadinessStatus(task: task)
        }
        return cell
    }
}

//MARK: UITableViewDelegate
extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            self.presenter?.deleteTask(task: self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionsConfiguration
    }
}
