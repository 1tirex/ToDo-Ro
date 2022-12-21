//
//  TaskListViewController.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

class TaskListViewController: UIViewController {
    
//    private var taskLists: [TaskLists] = []
    private let segmentControl = UISegmentedControl()
    private let tableView = UITableView()
    private static let cellID = "cell"
    
    private var viewModel: TaskListViewModelProtocol! {
        didSet {
            viewModel.fetchTaskList {
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = TaskListViewModel()
//        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc private func pushAddAction() {
        showAlert()
    }
    
    @objc private func pushEditAction() {
        
    }
    
    private func setupUI() {
        view.backgroundColor = .darkGray
        view.addSubview(tableView)
        view.addSubview(segmentControl)
        setupTableView()
        setupSegmentControl()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TaskListViewController.cellID)
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
    
    private func setupSegmentControl() {
        //        segmentControl
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupNavigationButtonItems()
    }
    
    private func setupNavigationButtonItems() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(pushAddAction))
        //        let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
        //                                         target: self,
        //                                         action: #selector(pushEditAction))
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
    
//    private func fetchData() {
//        StorageManager.shared.fetchData { [unowned self] result in
//            switch result {
//            case .success(let lists):
//                self.taskLists = lists
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let tasksVC = segue.destination as? TasksViewController else { return }
//        let taskList = viewModel.getTaskViewModel(at: indexPath)
        tasksVC.viewModel = sender as? TasksViewModelProtocol
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
//        taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListViewController.cellID, for: indexPath)
//        let taskList = taskLists[indexPath.row]
        cell.configure(with: viewModel.getTaskList(for: indexPath))
        //        var content = cell.defaultContentConfiguration()
        //        content.text = taskList.name
        //        cell.contentConfiguration = content
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let taskList = viewModel.getTaskList(for: indexPath)
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            viewModel.delete(taskList: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.deleteTaskList(taskList)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, isDone in
            showAlert(with: taskList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
            StorageManager.shared.doneTaskList(taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let taskVC = TasksViewController(taskList: viewModel.getTaskList(for: indexPath))
        navigationController?.pushViewController(taskVC, animated: true)
    }
}

extension TaskListViewController {
    
    private func showAlert(with taskList: TaskLists? = nil, completion: (() -> Void)? = nil) {
        let title = taskList != nil ? "Edit List" : "New List"
        let alert = UIAlertController.createAlert(withTitle: title,
                                                  andMessage: "Please set title for new task list")
        
        alert.action(with: taskList) { [weak self] newValue in
            if let taskList = taskList, let completion = completion {
                StorageManager.shared.editTaskList(taskList, newValue: newValue)
                completion()
            } else {
                self?.save(taskName: newValue)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func save(taskName: String) {
            viewModel.saveNew(taskList: taskName) { [unowned self] taskList in
                tableView.insertRows(
                    at: [IndexPath(row: viewModel.numberOfRows() - 1, section: 0)],
                    with: .automatic
                )
            }
    }
}
