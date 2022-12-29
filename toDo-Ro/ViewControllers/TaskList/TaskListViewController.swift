//
//  TaskListViewController.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

class TaskListViewController: UIViewController {
    
    // MARK: Visual Components
    private var alert = UIAlertController()
    private var addButton = UIBarButtonItem()
    private var editButton = UIBarButtonItem()
    private lazy var segmentControl = UISegmentedControl(items: viewModel.itemsSegmentController)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: Private Properties
    private var viewModel: TaskListViewModelProtocol! {
        didSet {
            viewModel.fetchTaskList {
            }
        }
    }
    
    // MARK: Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TaskListViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: objc Action
    @objc private func pushAddAction() {
        showAlert()
    }
    
    @objc private func pushEditAction() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            addButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Done"
            addButton.isEnabled = false
        }
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        viewModel.sortTaskList(segment: segmentedControl.selectedSegmentIndex) { [unowned self] in
            tableView.reloadData()
        }
    }
    
    @objc func handleIn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) { sender.alpha = 0.55 }
    }
    
    @objc func handleOut(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) { sender.alpha = 1 }
    }
    
    // MARK: Private Methods
    private func setupUI() {
        addSubviews(tableView, segmentControl)
        setBackgroundColor()
        setupTableView()
        setupSegmentControl()
        setupNavigationBar()
    }
    
    private func addSubviews(_ views: UIView...) {
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setBackgroundColor() {
        view.backgroundColor =
        UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.systemBackground
            default:
                return UIColor.systemGray6
            }
        }
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: viewModel.cellID)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.layer.cornerRadius = 10
        segmentControl.layer.borderColor = .none
        segmentControl.layer.masksToBounds = true
        
        segmentControl.addTarget(
            self,
            action: #selector(segmentAction(_:)),
            for: .valueChanged
        )
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        setupNavigationButtonItems()
    }
    
    private func setupNavigationButtonItems() {
        addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(pushAddAction))
        
        editButton.action = #selector(pushEditAction)
        editButton.title = "Edit"
        editButton.target = self
        
        navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    private func save(taskName: String) {
        viewModel.saveNew(taskList: taskName) { [unowned self] taskList in
            tableView.insertSections(IndexSet(integer: viewModel.numberOfSection() - 1), with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellID, for: indexPath)
        cell.configure(with: viewModel.getTaskList(for: indexPath))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let taskList = viewModel.getTaskList(for: indexPath)
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { [unowned self] _, _, _ in
            viewModel.delete(at: indexPath, taskList: taskList)
            tableView.deleteSections([indexPath.section], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit") { [unowned self] _, _, isDone in
            showAlert(with: taskList) {
                tableView.reloadSections([indexPath.section], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal,
                                            title: "Done") { [unowned self] _, _, isDone in
            viewModel.done(taskList: taskList)
            tableView.reloadSections([indexPath.section], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0, alpha: 1)
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let taskVC = TasksViewController()
        taskVC.viewModel = viewModel.getTaskViewModel(at: indexPath)
        navigationController?.pushViewController(taskVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension TaskListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        alert.actions
            .filter { $0.style == .default }
            .first?.isEnabled = viewModel.checkingIsEmpty(textField: textField.text)
    }
}

// MARK: - UIAlertController
extension TaskListViewController {
    private func showAlert(with taskList: TaskLists? = nil, completion: (() -> Void)? = nil) {
        
        let title = taskList != nil ? "Edit List" : "New List"
        
        alert = UIAlertController.createAlert(withTitle: title,
                                              andMessage: "Please set title for new task list")
        
        alert.action(with: taskList, for: alert, delegate: self) { [unowned self] newValue in
            
            if let taskList = taskList, let completion = completion {
                self.viewModel.editTaskList(taskList, newValue: newValue)
                completion()
            } else {
                self.save(taskName: newValue)
            }
        }
        present(alert, animated: true)
    }
}
