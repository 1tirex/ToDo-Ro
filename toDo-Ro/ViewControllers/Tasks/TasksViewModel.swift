//
//  TasksViewModel.swift
//  toDo-Ro
//
//  Created by Илья on 21.12.2022.
//

import Foundation

protocol TasksViewModelProtocol {
    
    var cellID: String { get }
    var taskName: String { get }
    var numberOfSections: Int { get }
    var currentTasks: Box<[Task]> { get }
    var completedTasks: Box<[Task]> { get }
    init(taskList: TaskLists)
    func numberOfRows(section: Int) -> Int
    func titleForHeader(section: Int) -> String
    func titleForAlert(task: Task?) -> String
    func titleForDoneAlert(for: IndexPath) -> String
    func getTask(from: IndexPath) -> Task
    func remove(from: Task)
    func editTask(_: Task, newName: String, newNote: String)
    func done(task: Task)
    func saveNew(task: String, note: String, completion: @escaping(Task) -> Void)
    func taskIndex(status: Bool) -> IndexPath
    func destinationIndexRow(for: IndexPath) -> IndexPath
    func checkingIsEmpty(textField: String?) -> Bool
}

final class TasksViewModel: TasksViewModelProtocol {
    
    var cellID: String {
        "cellID"
    }
    
    var taskName: String {
        taskList.name
    }
    
    var numberOfSections: Int {
        2
    }
    
    var currentTasks: Box<[Task]>
    var completedTasks: Box<[Task]>
    
    private let taskList: TaskLists
    
    init(taskList: TaskLists) {
        self.taskList = taskList
        currentTasks = Box(StorageManager.shared.fetchTasks(list: taskList, status: false))
        completedTasks = Box(StorageManager.shared.fetchTasks(list: taskList, status: true))
    }
    
    
    func numberOfRows(section: Int) -> Int {
        section == 0 ? currentTasks.value.count : completedTasks.value.count
    }
    
    func titleForHeader(section: Int) -> String {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    func titleForAlert(task: Task?) -> String {
        task != nil ? "Edit List" : "New List"
    }
    
    func titleForDoneAlert(for indexPath: IndexPath) -> String {
        indexPath.section == 0 ? "Done" : "Undone"
    }
    
    func getTask(from indexPath: IndexPath) -> Task {
        indexPath.section == 0
        ? currentTasks.value[indexPath.row]
        : completedTasks.value[indexPath.row]
    }
    
    func remove(from task: Task) {
        taskList.removeFromTasks(task)
        StorageManager.shared.deleteTask(task)
        setupTasksStatus()
    }
    
    func editTask(_ task: Task, newName: String, newNote: String) {
        StorageManager.shared.editTask(task, to: newName, withNote: newNote)
    }
    
    func taskIndex(status: Bool) -> IndexPath {
        status
        ? IndexPath(row: completedTasks.value.startIndex, section: 1)
        : IndexPath(row: currentTasks.value.startIndex, section: 0)
    }
    
    func done(task: Task) {
        StorageManager.shared.doneTask(task)
        setupTasksStatus()
    }
    
    func destinationIndexRow(for indexPath: IndexPath) -> IndexPath {
        indexPath.section == 0
        ? taskIndex(status: true)
        : taskIndex(status: false)
    }
    
    
    func saveNew(task: String, note: String, completion: @escaping (Task) -> Void) {
        StorageManager.shared.saveTask(task, withNote: note, to: taskList) { task in
            setupTasksStatus()
            completion(task)
        }
    }
    
    private func setupTasksStatus() {
        currentTasks.value = StorageManager.shared.fetchTasks(list: taskList, status: false)
        completedTasks.value = StorageManager.shared.fetchTasks(list: taskList, status: true)
    }
    
    func checkingIsEmpty(textField: String?) -> Bool {
        guard let text = textField else { return false}
        return !text.isEmpty ? true : false
    }
}
