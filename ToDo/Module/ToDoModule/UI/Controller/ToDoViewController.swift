//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

protocol ToDoViewProtocol: AnyObject {
    func updateView(tasks: [ToDo])
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
        presenter?.getTasks()
        reloadData()
    }
    
    //MARK: Setup
    func reloadData() {
        self.toDoView.reloadData()
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
        presenter?.showTaskManagerModule(task: task, action: .buttonAction)
    }
}

//MARK: ToDoViewProtocol
extension ToDoViewController: ToDoViewProtocol {
    func updateView(tasks: [ToDo]) {
        self.tasks = tasks
        reloadData()
    }
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
        cell.setupCell(title: task.title ?? "", date: task.date ?? Date(), description: task.description ?? "", bool: task.completed ?? false)
        cell.checkmarkImageViewAction = { [weak self] bool in
            task.completed = bool
            self?.tasks[indexPath.row] = task
            self?.presenter?.updateTaskReadinessStatus(task: task)
        }
        return cell
    }
}

//MARK: UITableViewDelegate
extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: AppAssets.deleteCell) { action, view, completion in
            self.presenter?.deleteTask(task: self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionsConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        presenter?.showTaskManagerModule(task: task, action: .cellAction)
    }
}
