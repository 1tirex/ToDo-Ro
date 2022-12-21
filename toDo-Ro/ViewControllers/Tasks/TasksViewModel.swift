//
//  TasksViewModel.swift
//  toDo-Ro
//
//  Created by Илья on 21.12.2022.
//

import Foundation

protocol TasksViewModelProtocol {
    var taskName: String { get }
    var currentTasks: Box<[Task]> { get }
    var completedTasks: Box<[Task]> { get }
    init(taskList: TaskLists)
    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func titleForHeader(section: Int) -> String
    func getTask(for: IndexPath) -> Task
    func remove(from: Task)
    func titleForDone(for: IndexPath) -> String
    func taskIndex(status: Bool) -> IndexPath
    func done(task: Task)
    func destinationIndexRow(for: IndexPath) -> IndexPath
    func saveNew(task: String, note: String, completion: @escaping(Task) -> Void)
//    func setupTasksStatus()
}

final class TasksViewModel: TasksViewModelProtocol {

    var taskName: String {
        taskList.name
    }
    
    var currentTasks: Box<[Task]>
    var completedTasks: Box<[Task]>
    
    private var taskList: TaskLists!
    
    init(taskList: TaskLists) {
        self.taskList = taskList
        currentTasks = Box(StorageManager.shared.tasks(list: taskList, status: false))
        completedTasks = Box(StorageManager.shared.tasks(list: taskList, status: true))
    }
    
    func numberOfSections() -> Int {
        2
    }
    
    func numberOfRows(section: Int) -> Int {
        section == 0 ? currentTasks.value.count : completedTasks.value.count
    }
    
    func titleForHeader(section: Int) -> String {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    func getTask(for indexPath: IndexPath) -> Task {
        indexPath.section == 0
        ? currentTasks.value[indexPath.row]
        : completedTasks.value[indexPath.row]
    }
    
    func remove(from task: Task) {
        taskList.removeFromTasks(task)
        StorageManager.shared.deleteTask(task)
        setupTasksStatus()
    }
    
    func titleForDone(for indexPath: IndexPath) -> String {
        indexPath.section == 0 ? "Done" : "Undone"
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
        StorageManager.shared.save(task, withNote: note, to: taskList) { task in
            setupTasksStatus()
            completion(task)
        }
    }
    
    private func setupTasksStatus() {
        currentTasks.value = StorageManager.shared.tasks(list: taskList, status: false)
        completedTasks.value = StorageManager.shared.tasks(list: taskList, status: true)
    }
}
