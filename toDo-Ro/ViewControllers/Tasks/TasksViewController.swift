//
//  TasksViewController.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

class TasksViewController: UIViewController {
    
    private let tableView = UITableView()
    private static let cellID = "cellID"
    
    var viewModel: TasksViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(taskList: TaskLists) {
        viewModel = TasksViewModel(taskList: taskList)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
    
    private func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TasksViewController.cellID)
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
        title = viewModel.taskName
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
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForHeader(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TasksViewController.cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = viewModel.getTask(for: indexPath)
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = viewModel.getTask(for: indexPath)
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            viewModel.remove(from: task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, isDone in
            showAlert(with: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: viewModel.titleForDone(for: indexPath)) { [unowned self] _, _, isDone in

            viewModel.done(task: task)
            let destinationIndexRow = viewModel.destinationIndexRow(for: indexPath)
            tableView.moveRow(at: indexPath, to: destinationIndexRow)
            isDone(true)
            
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
}

extension TasksViewController {
    
    private func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Edit List" : "New List"
        
        let alert = UIAlertController.createAlert(withTitle: title,
                                                  andMessage: "What do you want to do?")
        
        alert.action(with: task) { newValue, note in
            if let task = task, let completion = completion {
                StorageManager.shared.rename(task, to: newValue, withNote: note)
                completion()
            } else {
                self.save(task: newValue, withNote: note)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func save(task: String, withNote note: String) {
        viewModel.saveNew(task: task, note: note) { [unowned self] task in
            let rowIndex = viewModel.taskIndex(status: false)
            tableView.insertRows(at: [rowIndex], with: .automatic)
            tableView.reloadData()
        }
    }
}
