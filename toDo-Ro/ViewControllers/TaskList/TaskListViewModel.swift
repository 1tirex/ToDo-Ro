//
//  TaskListViewModel.swift
//  toDo-Ro
//
//  Created by Илья on 21.12.2022.
//

import Foundation

protocol TaskListViewModelProtocol {
    var itemsSegmentController: [String] { get }
    var cellID: String { get }
    func fetchTaskList(completion: @escaping() -> Void)
    func numberOfSection() -> Int
    func numberOfRows() -> Int
    func getTaskList(for: IndexPath) -> TaskLists
    func delete(at indexPath: IndexPath, taskList: TaskLists)
    func done(taskList: TaskLists)
    func editTaskList(_: TaskLists, newValue: String)
    func saveNew(taskList: String, completion: @escaping (TaskLists) -> Void)
    func sortTaskList(segment: Int, completion: @escaping () -> Void)
    func getTaskViewModel(at: IndexPath) -> TasksViewModelProtocol
    func checkingIsEmpty(textField: String?) -> Bool
}

final class TaskListViewModel: TaskListViewModelProtocol {
    var itemsSegmentController: [String] {
        ["Date", "A-Z"]
    }
    
    var cellID: String {
        "cell"
    }
    
    private var taskLists: [TaskLists] = []
    
    func fetchTaskList(completion: @escaping () -> Void) {
        StorageManager.shared.fetchTaskLists { [unowned self] result in
            switch result {
            case .success(let lists):
                self.taskLists = lists
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func numberOfSection() -> Int {
        taskLists.count
    }
    
    func numberOfRows() -> Int {
        1
    }
    
    func getTaskList(for indexPath: IndexPath) -> TaskLists {
        taskLists[indexPath.section] //taskLists[indexPath.row]
    }
    
    func delete(at indexPath: IndexPath, taskList: TaskLists) {
        taskLists.remove(at: indexPath.section)
        StorageManager.shared.deleteTaskList(taskList)
    }
    
    func done(taskList: TaskLists) {
        StorageManager.shared.doneTaskList(taskList)
    }
    
    func editTaskList(_ list: TaskLists, newValue: String) {
        StorageManager.shared.editTaskList(list, newValue: newValue)
    }
    
    func getTaskViewModel(at indexPath: IndexPath) -> TasksViewModelProtocol {
        TasksViewModel(taskList: taskLists[indexPath.section])
    }
    
    func saveNew(taskList: String, completion: @escaping (TaskLists) -> Void) {
        StorageManager.shared.saveTaskList(name: taskList) { [unowned self] taskList in
            taskLists.append(taskList)
            print(taskList)
            print(taskLists)
            completion(taskList)
        }
    }
    
    func sortTaskList(segment: Int, completion: @escaping () -> Void) {
        taskLists = segment == 0
        ? taskLists.sorted(by: { $0.date < $1.date })
        : taskLists.sorted(by: { $0.name < $1.name })
        completion()
    }
    
    func checkingIsEmpty(textField: String?) -> Bool {
        guard let text = textField else { return false}
        return !text.isEmpty ? true : false
    }
}
