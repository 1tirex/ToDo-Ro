//
//  TasksViewController.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

class TasksViewController: UIViewController {
    
    var taskList: TaskLists!
    private var currentTasks: [Task] = []
    private var completedTasks: [Task] = []
    private let tableView = UITableView()
    private static let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc private func addButtonPressed() {
//        showAlert()
    }
    
    private func setupUI() {
        setupNavigationBar()
//        currentTasks = taskList.tasks?.filter()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UITableView.self, forCellReuseIdentifier: TasksViewController.cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = taskList.name
        navigationItem.rightBarButtonItems = [editButtonItem]
        setupNavigationButtonItems()
    }
    
    private func setupNavigationButtonItems() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addButtonPressed))
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
}

extension TasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TasksViewController.cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
}

extension TasksViewController: UITableViewDelegate {
    
}
