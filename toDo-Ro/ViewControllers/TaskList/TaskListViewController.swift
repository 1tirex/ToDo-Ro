//
//  TaskListViewController.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

final class TaskListViewController: UIViewController {
    
    // MARK: Visual Components
    private var alert = UIAlertController()
    private var addButton = UIBarButtonItem()
    private var sortNameButton = UIButton()
    private var sortDateButton = UIButton()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let backgroundImage = UIImageView()
    
    // MARK: Private Properties
    private var viewModel: TaskListViewModelProtocol! {
        didSet {
            viewModel.fetchTaskList(.persistent) {
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
}

extension TaskListViewController {
    // MARK: objc Action
    @objc private func pushAddAction() {
        showAlert()
    }
    
    @objc private func pushEditAction() {
        pressedEditButton()
    }
    
    @objc private func pushSortAction(_ sender: UIButton) {
        viewModel.sortButtonPressed()
        sortingNameButton(sender)
    }
    
    @objc func handleIn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) { sender.alpha = 0.55 }
    }
    
    @objc func handleOut(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) { sender.alpha = 1 }
    }
    
    // MARK: Private Methods
    private func setupUI() {
        addSubviews(tableView, sortDateButton, sortNameButton, backgroundImage)
        setBackgroundColor()
        setupTableView()
        setupNavigationBar()
        setupSortButton()
        setupSortDateButton()
        setupBackgroundImage()
        makeSystem(sortNameButton)
        makeSystem(sortDateButton)
    }
    
    private func addSubviews(_ views: UIView...) {
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setBackgroundColor() {
        view.backgroundColor =
        UIColor { [unowned self] traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                self.backgroundImage.image = UIImage(named: "ObjectDark")
                return UIColor.systemBackground
            default:
                self.backgroundImage.image = UIImage(named: "OBJECTS")
                return UIColor.systemGray6
            }
        }
    }
    
    private func setupBackgroundImage() {
        NSLayoutConstraint.activate([
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(TaskListTableViewCell.self,forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sortNameButton.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
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
        
        editButtonItem.action = #selector(pushEditAction)
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
    
    private func setupButton(_ sender: UIButton) {
        sender.setTitleColor(.label, for: .normal)
        sender.layer.cornerRadius = 5
        sender.backgroundColor =
        UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .systemGray6
            default:
                return .systemGray5
            }
        }
        
        sender.addTarget(
            self,
            action: #selector(pushSortAction(_:)),
            for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            sender.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sender.widthAnchor.constraint(equalToConstant: 80),
            sender.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupSortButton() {
        sortNameButton.setTitle("A - Z", for: .normal)
        setupButton(sortNameButton)
        
        NSLayoutConstraint.activate([
            sortNameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        ])
    }
    
    private func setupSortDateButton() {
        sortDateButton.setTitle("Date", for: .normal)
        setupButton(sortDateButton)
        
        NSLayoutConstraint.activate([
            sortDateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func pressedEditButton() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButtonItem.title = "Edit"
            addButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editButtonItem.title = "Done"
            addButton.isEnabled = false
        }
    }
    
    private func sortingNameButton(_ sender: UIButton) {
        defoltButtonView(sortDateButton)
        defoltButtonView(sortNameButton)
        
        switch sender {
        case sortNameButton:
            viewModel.sortTaskList(type: .name) {
                DispatchQueue.main.async { [unowned self] in
                    tableView.reloadData()
                }
            }
        default:
            viewModel.sortTaskList(type: .date) {
                DispatchQueue.main.async { [unowned self] in
                    tableView.reloadData()
                }
            }
        }
        sender.setImage(swapArrowButton(status: viewModel.status.value), for: .normal)
    }
    
    private func defoltButtonView(_ button: UIButton) {
        button.setImage(nil, for: .normal)
    }
    
    private func swapArrowButton(status: Bool) -> UIImage? {
        status
        ? UIImage(named: "downArrow")?.withRenderingMode(.alwaysTemplate)
        : UIImage(named: "dowArrow")?.withRenderingMode(.alwaysTemplate)
    }
    
    private func save(taskName: String) {
        viewModel.saveNew(taskList: taskName) { [unowned self] taskList in
            tableView.insertSections(IndexSet(integer: viewModel.numberOfSection - 1), with: .automatic)
        }
    }
    
    private func itemsIsHiddenInTableView() -> Int {
        if viewModel.numberOfSection == 0 {
            sortNameButton.isHidden = true
            sortDateButton.isHidden = true
            backgroundImage.isHidden = false
            return 0
        } else {
            backgroundImage.isHidden = true
            sortNameButton.isHidden = false
            sortDateButton.isHidden = false
            return viewModel.numberOfSection
        }
    }
    
    private func makeSystem(_ button: UIButton) {
        button.addTarget(self, action: #selector(handleIn(_:)), for: [
            .touchDown,
            .touchDragInside
        ])
        
        button.addTarget(self, action: #selector(handleOut(_:)), for: [
            .touchDragOutside,
            .touchUpInside,
            .touchUpOutside,
            .touchDragExit,
            .touchCancel
        ])
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        itemsIsHiddenInTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = cell as? TaskListTableViewCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getTaskListCellViewModel(at: indexPath)
//        cell.configure()
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellID, for: indexPath)
        
//        cell.configure(with: viewModel.getTaskList(for: indexPath))
//        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = viewModel.getTaskList(for: indexPath)
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete") { [unowned self] _, _, _ in
                viewModel.delete(at: indexPath, taskList: taskList)
                tableView.deleteSections([indexPath.section], with: .automatic)
            }
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "Edit") { [unowned self] _, _, isDone in
                showAlert(with: taskList) {
                    tableView.reloadSections([indexPath.section], with: .automatic)
                }
                isDone(true)
        }
        
        let doneAction = UIContextualAction(
            style: .normal,
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
        
        alert = UIAlertController.createAlert(
            withTitle: viewModel.titleForAlert(taskList),
            andMessage: "Please set title for new task list")
        
        alert.action(with: taskList,
                     for: alert,
                     delegate: self) { [unowned self] newValue in
            
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
