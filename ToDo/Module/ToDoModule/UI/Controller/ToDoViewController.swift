//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

protocol ToDoViewProtocol: AnyObject {
    func updateView(tasks: [ToDo])
    func updateCurrentDate(date: Date)
    func startTheCurrentDateUpdateTimer(date: Date)
}

final class ToDoViewController: UIViewController {
    
    //MARK: Public
    var presenter: ToDoPresenterProtocol?
    
    //MARK: Private
    private let toDoView = ToDoView()
    private var tasks: [ToDo] = []
    private var filteredTasks: [ToDo] = []
    private var tagButtonView: Int = 1
    
    //MARK: View lifecycle
    override func loadView() {
        super.loadView()
        view = toDoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoView.setupDelegateAndDataSource(delegate: self, dataSource: self)
        newTaskButtonTapped()
        buttonViewTapped()
        presenter?.getCurrentDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getTasks()
        tagButtonView = 1
        toDoView.setColorForButtonView()
        reloadData()
        
    }
    
    //MARK: Setup
    func reloadData() {
        setTheNumberOfTasks()
        self.toDoView.reloadData()
    }
    
    private func updateTasksDependingOnTag() {
        switch tagButtonView {
        case 1:
            filteredTasks = tasks
            reloadData()
        case 2:
            filteredTasks = tasks.filter { !$0.completed! }
            reloadData()
        case 3:
            filteredTasks = tasks.filter { $0.completed! }
            reloadData()
        default:
            return
        }
    }
    
    private func updateStatusTask(task: ToDo, indexPath: IndexPath) {
        filteredTasks[indexPath.row] = task
        var indexItem: Int?
        for (index, item) in tasks.enumerated() {
            if item.id == task.id {
                indexItem = index
            }
        }
        guard let index = indexItem else {
            return
        }
        tasks[index] = task
        updateTasksDependingOnTag()
        setTheNumberOfTasks()
        reloadData()
        presenter?.updateTaskReadinessStatus(task: task)
    }
    
    private func deleteTask(task: ToDo) {
        presenter?.deleteTask(task: task)
        var indexItem: Int?
        for (index, item) in tasks.enumerated() {
            if item.id == task.id {
                indexItem = index
            }
        }
        guard let index = indexItem else {
            return
        }
        tasks.remove(at: index)
        updateTasksDependingOnTag()
        setTheNumberOfTasks()
    }
    
    private func setTheNumberOfTasks() {
        let openTasks = tasks.filter { !$0.completed! }
        let closedTasks = tasks.filter { $0.completed! }
        toDoView.setTheNumberOfTasks(all: tasks.count, open: openTasks.count, closed: closedTasks.count)
    }
    
    private func newTaskButtonTapped() {
        toDoView.newTaskButtonAction = { [weak self] in
            let task = ToDo()
            self?.presenter?.showTaskManagerModule(task: task, action: .buttonAction)
        }
    }
    
    private func buttonViewTapped() {
        toDoView.buttonViewAction = { [weak self] sender in
            guard let tag = sender.view?.tag else {
                return
            }
            switch tag {
            case 1:
                self?.tagButtonView = 1
            case 2:
                self?.tagButtonView = 2
            case 3:
                self?.tagButtonView = 3
            default:
                return
            }
            self?.updateTasksDependingOnTag()
        }
    }
}

//MARK: ToDoViewProtocol
extension ToDoViewController: ToDoViewProtocol {
    func startTheCurrentDateUpdateTimer(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let calendarDate = calendar.date(from: components) else {
            return
        }
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendarDate) else {
            return
        }
        guard let secondsUntilNextDay = calendar.dateComponents([.second], from: date, to: tomorrow).second else {
            return
        }
        print(secondsUntilNextDay)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(secondsUntilNextDay)) {
            self.presenter?.getCurrentDate()
        }
    }
    
    func updateCurrentDate(date: Date) {
        toDoView.setCurrentDate(date: date)
    }
    
    func updateView(tasks: [ToDo]) {
        self.tasks = tasks
        filteredTasks = tasks
        updateTasksDependingOnTag()
        reloadData()
    }
}

//MARK: UITableViewDataSource
extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ToDoCell.self), for: indexPath) as? ToDoCell else {
            return UITableViewCell()
        }
        var task = filteredTasks[indexPath.row]
        cell.setupCell(title: task.title ?? "", date: task.date ?? Date(), description: task.description ?? "", bool: task.completed ?? false)
        cell.checkmarkImageViewAction = { [weak self] bool in
            task.completed = bool
            self?.updateStatusTask(task: task, indexPath: indexPath)
        }
        return cell
    }
}

//MARK: UITableViewDelegate
extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: AppAssets.deleteCell) { action, view, completion in
            self.deleteTask(task: self.filteredTasks[indexPath.row])
            completion(true)
        }
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionsConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = filteredTasks[indexPath.row]
        presenter?.showTaskManagerModule(task: task, action: .cellAction)
    }
}
