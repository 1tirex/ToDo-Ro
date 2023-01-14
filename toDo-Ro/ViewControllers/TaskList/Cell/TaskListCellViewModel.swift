//
//  TaskListCellViewModel.swift
//  toDo-Ro
//
//  Created by Дмитрий Собин on 14.01.23.
//

import Foundation

protocol TaskListCellViewModelProtocol {
    var taskListName: String { get }
    var noteText: String { get }
    var currentTasksCount: Int { get }
    var procent: Double { get }
//    var currentTasks: Box<[Task]> { get }
    init(taskList: TaskLists)
}

class TaskListCellViewModel: TaskListCellViewModelProtocol {
    var taskListName: String {
        taskList.name
    }
    
    var noteText: String {
        """
        \(currentTasks.count) current tasks.
        Create list at \(taskList.date.formatted(date: .abbreviated, time: .shortened) )
        """
    }
    
    var procent: Double {
        taskList.tasks?.count == 0
               ? 0
               : Double(currentTasksCount) / Double(taskList.tasks?.count ?? 1) * 10
    }
    
    var currentTasksCount: Int {
        currentTasks.count
    }
    
    private var currentTasks: [Task] {
        StorageManager.shared.fetchTasks(list: taskList).filter { $0.isComplete == false }
    }
    
    private var taskList: TaskLists
        
    required init(taskList: TaskLists) {
        self.taskList = taskList
//        procent = Box()
//        currentTasks = StorageManager.shared.fetchTasks(list: taskList).filter { $0.isComplete == false }
    }
}
