//
//  TaskListViewModel.swift
//  toDo-Ro
//
//  Created by Илья on 21.12.2022.
//

import Foundation
protocol TaskListViewModelProtocol {
    func fetchTaskList(completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func getTaskList(for: IndexPath) -> TaskLists
    func delete(taskList: IndexPath)
    func saveNew(taskList: String, completion: @escaping (TaskLists) -> Void)
    func getTaskViewModel(at: IndexPath) -> TasksViewModelProtocol
//    func getTask
}

final class TaskListViewModel: TaskListViewModelProtocol {
    private var taskLists: [TaskLists] = []
    
    func fetchTaskList(completion: @escaping () -> Void) {
        StorageManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let lists):
                self.taskLists = lists
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func numberOfRows() -> Int {
        taskLists.count
    }
    
    func getTaskList(for indexPath: IndexPath) -> TaskLists {
        taskLists[indexPath.row]
    }
    
    func delete(taskList indexPath: IndexPath) {
        taskLists.remove(at: indexPath.row)
    }
    
    func getTaskViewModel(at indexPath: IndexPath) -> TasksViewModelProtocol {
        TasksViewModel(taskList: taskLists[indexPath.row])
    }
    
    func saveNew(taskList: String, completion: @escaping (TaskLists) -> Void) {
        StorageManager.shared.createTaskList(name: taskList) { [unowned self] taskList in
            taskLists.append(taskList)
            completion(taskList)
        }
    }
}
