//
//  TaskListViewModel.swift
//  toDo-Ro
//
//  Created by Илья on 21.12.2022.
//

import Foundation

enum TypeSort {
    case date, name
}

protocol TaskListViewModelProtocol {
    var status: Box<Bool> { get }
    var cellID: String { get }
    var numberOfSection: Int { get }
    var numberOfRows: Int { get }
    func fetchTaskList(_: StorageType, completion: @escaping () -> Void)
    func getTaskList(for: IndexPath) -> TaskLists
    func delete(at indexPath: IndexPath, taskList: TaskLists)
    func done(taskList: TaskLists)
    func editTaskList(_: TaskLists, newValue: String)
    func saveNew(taskList: String, completion: @escaping (TaskLists) -> Void)
    func sortTaskList(type: TypeSort, completion: @escaping () -> Void)
    func getTaskViewModel(at: IndexPath) -> TasksViewModelProtocol
    func getTaskListCell(at: IndexPath) -> TaskListsCellProtocol
    func titleForAlert(_: TaskLists?) -> String
    func checkingIsEmpty(textField: String?) -> Bool
    func sortButtonPressed()
}

final class TaskListViewModel: TaskListViewModelProtocol {
    
    var status: Box<Bool>
    
    var cellID: String {
        "cell"
    }
    
    var numberOfSection: Int {
        taskLists.count
    }
    
    var numberOfRows: Int {
        1
    }
    
    private var taskLists: [TaskLists] = []
    
    required init() {
        status = Box(true)
    }
    
    func sortButtonPressed() {
        status.value.toggle()
    }
    
    func fetchTaskList(_ storageType: StorageType = .inMemory, completion: @escaping () -> Void) {
        switch storageType {
        case .persistent:
            StorageManager.shared.fetchTaskLists { [unowned self] result in
                switch result {
                case .success(let lists):
                    self.taskLists = lists
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case .inMemory:
            let temporaryStorage = StorageManager(modelName: "toDo_Ro", .inMemory)
            temporaryStorage.saveTaskList(name: "foo") {_ in }
            temporaryStorage.saveTaskList(name: "bar") {_ in }
            temporaryStorage.fetchTaskLists { [unowned self] result in
                switch result {
                case .success(let lists):
                    self.taskLists = lists
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func titleForAlert(_ title: TaskLists?) -> String {
        title != nil ? "Edit List" : "New List"
    }
    
    func getTaskList(for indexPath: IndexPath) -> TaskLists {
        taskLists[indexPath.section]
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
    
    func getTaskListCell(at indexPath: IndexPath) -> TaskListsCellProtocol {
        TaskListsCellViewModel(list: taskLists[indexPath.section])
    }
    
    func saveNew(taskList: String, completion: @escaping (TaskLists) -> Void) {
        StorageManager.shared.saveTaskList(name: taskList) { [unowned self] taskList in
            taskLists.append(taskList)
            completion(taskList)
        }
    }
    
    func sortTaskList(type: TypeSort, completion: @escaping () -> Void) {
        switch type {
        case .date:
            taskLists = status.value
            ? taskLists.sorted(by: { $0.date < $1.date })
            : taskLists.sorted(by: { $0.date > $1.date })
        case .name:
            taskLists = status.value
            ? taskLists.sorted(by: { $0.name < $1.name })
            : taskLists.sorted(by: { $0.name > $1.name })
        }
        completion()
    }
    
    func checkingIsEmpty(textField: String?) -> Bool {
        guard let text = textField else { return false}
        return !text.isEmpty ? true : false
    }
}
