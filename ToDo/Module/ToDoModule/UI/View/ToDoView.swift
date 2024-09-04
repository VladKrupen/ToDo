//
//  ToDoView.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

final class ToDoView: UIView {
    
    var newTaskButtonAction: (() -> Void)?
    var buttonViewAction: ((UITapGestureRecognizer) -> Void)?
    
    //MARK: UI
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.text = AppAssets.titleToDoModule
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return $0
    }(UILabel())
    
    private let dayOfTheWeekLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.text = "Wednesday, 11 May"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        return $0
    }(UILabel())
    
    private lazy var newTaskButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(AppAssets.newTaskButton, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.backgroundColor = UIColor(red: 0.890, green: 0.922, blue: 0.976, alpha: 1)
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(newTaskButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    private let vStackLabel: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 5
        return $0
    }(UIStackView())
    
    private let allButtonView: CustomButtonViewToDoModule = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(title: "All")
        $0.setColor(color: .systemBlue)
        return $0
    }(CustomButtonViewToDoModule())
    
    private let openButtonView: CustomButtonViewToDoModule = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(title: "Open")
        $0.setColor(color: .systemGray2)
        return $0
    }(CustomButtonViewToDoModule())
    
    private let closedButtonView: CustomButtonViewToDoModule = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(title: "Closed")
        $0.setColor(color: .systemGray2)
        return $0
    }(CustomButtonViewToDoModule())
    
    private let separatorBetweenButtons: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemGray2
        $0.widthAnchor.constraint(equalToConstant: 2).isActive = true
        return $0
    }(UIView())
    
    private let hStackButtonView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.backgroundColor = .systemGray6
        $0.register(ToDoCell.self, forCellReuseIdentifier: String(describing: ToDoCell.self))
        return $0
    }(UITableView())
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        layoutElements()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setupDelegateAndDataSource(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func setTheNumberOfTasks(all: Int, open: Int, closed: Int) {
        allButtonView.setQuantity(quantity: all)
        openButtonView.setQuantity(quantity: open)
        closedButtonView.setQuantity(quantity: closed)
    }
    
    func setColorForButtonView() {
        allButtonView.setColor(color: .systemBlue)
        openButtonView.setColor(color: .systemGray2)
        closedButtonView.setColor(color: .systemGray2)
    }
    
    private func setupTapGesture() {
        allButtonView.tag = 1
        openButtonView.tag = 2
        closedButtonView.tag = 3
        let allTapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonViewTapped))
        let openTapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonViewTapped))
        let closedTapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonViewTapped))
        allButtonView.addGestureRecognizer(allTapGesture)
        openButtonView.addGestureRecognizer(openTapGesture)
        closedButtonView.addGestureRecognizer(closedTapGesture)
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutVStackLabel()
        layoutNewTaskButton()
        layoutHStackButtonView()
        layoutTableView()
    }
    
    private func layoutVStackLabel() {
        addSubview(vStackLabel)
        [titleLabel, dayOfTheWeekLabel].forEach { vStackLabel.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            vStackLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            vStackLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
        ])
    }
    
    private func layoutNewTaskButton() {
        addSubview(newTaskButton)
        
        NSLayoutConstraint.activate([
            newTaskButton.heightAnchor.constraint(equalToConstant: 40),
            newTaskButton.widthAnchor.constraint(equalToConstant: 120),
            newTaskButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newTaskButton.centerYAnchor.constraint(equalTo: vStackLabel.centerYAnchor),
            newTaskButton.leadingAnchor.constraint(equalTo: vStackLabel.trailingAnchor)
        ])
    }
    
    private func layoutHStackButtonView() {
        addSubview(hStackButtonView)
        [allButtonView, separatorBetweenButtons, openButtonView, closedButtonView].forEach { hStackButtonView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            hStackButtonView.topAnchor.constraint(equalTo: vStackLabel.bottomAnchor, constant: 30),
            hStackButtonView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
        ])
    }
    
    private func layoutTableView() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: hStackButtonView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

//MARK: OBJC
extension ToDoView {
    @objc private func newTaskButtonTapped() {
        newTaskButtonAction?()
    }
    
    @objc private func buttonViewTapped(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        allButtonView.setColor(color: tag == 1 ? .systemBlue : .systemGray2)
        openButtonView.setColor(color: tag == 2 ? .systemBlue : .systemGray2)
        closedButtonView.setColor(color: tag == 3 ? .systemBlue : .systemGray2)
        buttonViewAction?(sender)
    }
}
