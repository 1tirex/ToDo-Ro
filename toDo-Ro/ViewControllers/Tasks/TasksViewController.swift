//
//  TasksViewController.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

class TasksViewController: UIViewController {
    
    // MARK: Visual Components
    private var alert = UIAlertController()
    private let tableView = UITableView()
    
    // MARK: Public Properties
    var viewModel: TasksViewModelProtocol!
    
    // MARK: Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension TasksViewController {
    // MARK: objc Action
    @objc private func addButtonPressed() {
        showAlert()
    }
    
    @objc private func pushEditAction() {
        pressedEditButton()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.cellID)
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
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed))
        
        editButtonItem.action = #selector(pushEditAction)
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
    
    private func pressedEditButton() {
        let addButton = navigationItem.rightBarButtonItems?.first { $0.action == #selector(addButtonPressed) }
        
        if tableView.isEditing {
            DispatchQueue.main.async { [unowned self] in
                tableView.setEditing(false, animated: true)
                addButton?.isEnabled = true
                editButtonItem.title = "Edit"
            }
        } else {
            DispatchQueue.main.async { [unowned self] in
                tableView.setEditing(true, animated: true)
                addButton?.isEnabled = false
                editButtonItem.title = "Done"
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension TasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForHeader(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellID, for: indexPath)
        let task = viewModel.getTask(from: indexPath)
        cell.configure(with: task, index: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = viewModel.getTask(from: indexPath)
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete") { [unowned self] _, _, _ in
                viewModel.remove(from: task)
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
        }
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "Edit") { [unowned self] _, _, isDone in
                showAlert(with: task) {
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                isDone(true)
        }
        
        let doneAction = UIContextualAction(
            style: .normal,
            title: viewModel.titleForDoneAlert(for: indexPath)) { [unowned self] _, _, isDone in
                
                viewModel.done(task: task)
                DispatchQueue.main.async { [unowned self] in
                    tableView.moveRow(at: indexPath, to: viewModel.destinationIndexRow(for: indexPath))
                }
                isDone(true)
        }
        editAction.backgroundColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0, alpha: 1)
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.getTask(from: indexPath)
        
        DispatchQueue.main.async { [unowned self] in
            tableView.deselectRow(at: indexPath, animated: true)
            viewModel.done(task: task)
            tableView.moveRow(at: indexPath, to: viewModel.destinationIndexRow(for: indexPath))
        }
    }
}

// MARK: - UITextFieldDelegate
extension TasksViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        alert.actions
            .filter { $0.style == .default }
            .first?.isEnabled = viewModel.checkingIsEmpty(textField: textField.text)
    }
}

// MARK: - UIAlertController
extension TasksViewController {
    private func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        
        alert = UIAlertController.createAlert(withTitle: viewModel.titleForAlert(task: task),
                                              andMessage: "What do you want to do?")
        
        alert.action(with: task, for: alert, delegate: self) { [unowned self] newValue, note in
            if let task = task, let completion = completion {
                viewModel.editTask(task, newName: newValue, newNote: note)
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
